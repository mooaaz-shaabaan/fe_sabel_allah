import 'package:fe_sabel_allah/screens/add_member/add_member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../logic/details_groub/details_groub_cubit.dart';
import '../../logic/details_groub/details_groub_state.dart';
import '../../model/card_model.dart';
import '../add_{exit_and_visits}_record_screen/add_exit_record_screen.dart';
import 'widgets/khroj_card.dart';
import 'widgets/custom_search_field.dart';
import 'widgets/member_card.dart';
import 'widgets/top_section_groub_details.dart';
import 'widgets/visits_card.dart';

class DetailsGroubScreen extends StatelessWidget {
  const DetailsGroubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsGroubCubit(),
      child: DefaultTabController(
        length: 3,
        child: BlocListener<DetailsGroubCubit, DetailsGroubState>(
          listener: (context, state) {
            // منطق الـ Navigation زي ما هو
            if (state is NavigateToAddMemberState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const AddMemberScreen()),
              );
            } else if (state is NavigateToAddVisitState ||
                state is NavigateToAddKhrojState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const AddExitRecordScreen()),
              );
            }
          },
          // هنا بقى خلينا الـ BlocBuilder يلف الـ Scaffold كله
          child: BlocBuilder<DetailsGroubCubit, DetailsGroubState>(
            builder: (context, state) {
              DetailsGroubCubit obj = context.read<DetailsGroubCubit>();
              return Scaffold(
                backgroundColor: AppColors.secondary,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    obj.acctionFAB(currentIndex: state.currentIndex);
                  },
                  backgroundColor: AppColors.primary,
                  label: Icon(
                    // الأيقونة بتتغير حسب الـ state اللي ماسكة الـ screen كلها
                    state.currentIndex == 0
                        ? CupertinoIcons.person_add
                        : state.currentIndex == 1
                        ? CupertinoIcons.location
                        : CupertinoIcons.clear,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                body: Column(
                  children: [
                    const TopSectionGroubDetails(),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.r),
                            topRight: Radius.circular(25.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            const CustomSearchField(),
                            TabBar(
                              onTap: (index) {
                                obj.updateIndex(index);
                              },
                              indicatorColor: AppColors.primary,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              labelStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              tabs: const [
                                Tab(text: 'الأعضاء'),
                                Tab(text: 'الزيارات'),
                                Tab(text: 'الخروج'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // بنبعت اللستة اللي جوه الـ cubit للميثود
                                  _buildMembersList(state.members),
                                  _buildVisitsList(state.members),
                                  _buildKhrogsList(state.members),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ميثود الأعضاء بتاخد البيانات من الـ Cubit دلوقتي
  Widget _buildMembersList(List<MembersModel> membersData) {
    if (membersData.isEmpty) {
      return const Center(child: Text("لا يوجد أعضاء حالياً"));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: membersData.length,
      itemBuilder: (context, index) => MemberCard(
        onTap: () {
          context.read<DetailsGroubCubit>().toggleKhareg(index);
        },
        membersData: membersData[index],
      ),
    );
  }

  // باقي الـ Widgets (Visits و Khrogs) زي ما هي...
  Widget _buildVisitsList(List<MembersModel> membersData) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: 1,
      itemBuilder: (context, index) =>
          VisitsCard(membersData: membersData[index]),
    );
  }

  Widget _buildKhrogsList(List<MembersModel> membersData) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: 1,
      itemBuilder: (context, index) =>
          KhrogCard(membersData: membersData[index]),
    );
  }
}
