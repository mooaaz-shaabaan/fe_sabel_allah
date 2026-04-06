import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../logic/home_screen/home_cubit.dart';
import '../../logic/home_screen/home_state.dart';
import '../../logic/user/user_cubit.dart';
import '../../model/groub_model.dart';
import '../../model/user_model.dart';
import '../../shared/check_connection.dart';
import '../../shared/user_local_storage.dart';
import '../details_groub/details_groub_screen.dart';
import 'widgets/add_groub_bottom_sheet.dart';
import 'widgets/custom_card_groubs.dart';
import 'widgets/drawer_widget.dart';
import 'widgets/top_section_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Builder(
        builder: (context) {
          // فحص اليوزر بعد بناء الواجهة
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkUserAndShowDialog(context);
          });

          return Scaffold(
            drawer: const DrawerWidget(),
            backgroundColor: AppColors.primary,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final hasConnection = await checkConnection(context);
                if (!hasConnection) return;
                _showAddGroupSheet(context);
              },
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: Column(
              children: [
                const TopSectionHomeScreen(),
                SizedBox(height: 30.h),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    // في حالة النجاح أو عرض المجموعات
                    if (state is HomeLoaded ||
                        state is HomeSuccess ||
                        state is HomeError) {
                      final List<GroupModel> groups = (state is HomeLoaded)
                          ? state.groups
                          : (state is HomeSuccess)
                          ? state.groups
                          : (state is HomeError)
                          ? state.groups
                          : [];

                      return CustomCardGroubs(
                        groups: groups,
                        isLoading: false,
                        onTap: (group) {
                          // هنا نمرر كائن الجروب بالكامل
                          // التنقل لصفحة تفاصيل المجموعة مع تمرير الموديل كاملاً
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) =>
                                  DetailsGroubScreen(groupModel: group),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- المنطق الخاص باليوزر ---

  void _checkUserAndShowDialog(BuildContext context) {
    final user = UserLocalStorage.getUser();

    if (user?.name == 'بالأحباب' || user?.name == null) {
      _showNameDialog(context);
    } else {
      context.read<HomeCubit>().setUser(user!);
    }
  }

  void _showNameDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: const Text(
              'سجل اسمك',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                style: const TextStyle(color: AppColors.black),
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'اكتب اسمك هنا...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: AppColors.secondary),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'الاسم مطلوب'
                    : null,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final currentUser = FirebaseAuth.instance.currentUser!;
                      String name = nameController.text.trim();

                      final newUser = UserModel(
                        id: currentUser.uid,
                        name: name,
                        email: currentUser.email,
                        photoUrl: currentUser.photoURL,
                      );

                      context.read<HomeCubit>().setUser(newUser);
                      await context.read<UserCubit>().updateUser(newUser);

                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    'دخول',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddGroupSheet(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: homeCubit,
        child: AddGroupBottomSheet(homeCubit: homeCubit),
      ),
    );
  }
}
