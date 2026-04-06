import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../logic/add_member/add_member_cubit.dart';
import '../../logic/details_groub/details_groub_cubit.dart';
import '../../logic/details_groub/details_groub_state.dart';
import '../../model/groub_model.dart';
import '../../model/member_model.dart';
import '../../shared/check_connection.dart';
import '../add_member/add_member_screen.dart';
import '../add_khrog_record_screen/add_khrog_record_screen.dart';
import '../add_visit_recoed_screen/add_visit_record_screen.dart';
import 'widgets/custom_search_field.dart';
import 'widgets/member_card.dart';
import 'widgets/top_section_groub_details.dart';
import 'widgets/visits_filter_widget.dart';

class DetailsGroubScreen extends StatefulWidget {
  const DetailsGroubScreen({super.key, required this.groupModel});
  final GroupModel groupModel;

  @override
  State<DetailsGroubScreen> createState() => _DetailsGroubScreenState();
}

class _DetailsGroubScreenState extends State<DetailsGroubScreen> {
  final ValueNotifier<VisitFilter> _filterNotifier = ValueNotifier(
    VisitFilter.most,
  );

  @override
  void dispose() {
    _filterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsGroubCubit(groupId: widget.groupModel.id),
      child: DefaultTabController(
        length: 3,
        child: BlocListener<DetailsGroubCubit, DetailsGroubState>(
          listenWhen: (previous, current) => current.navigateTo != null,
          listener: (context, state) {
            final cubit = context.read<DetailsGroubCubit>();

            if (state.navigateTo == 'addMember') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => AddMemberScreen(detailsGroubCubit: cubit),
                ),
              ).then((_) => cubit.clearNavigation());
            } else if (state.navigateTo == 'addVisit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => BlocProvider.value(
                    value: cubit,
                    child: AddVisitRecordScreen(
                      stateDetails: state,
                      groupModel: widget.groupModel,
                    ),
                  ),
                ),
              ).then((_) => cubit.clearNavigation());
            } else if (state.navigateTo == 'addKhroj') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => BlocProvider.value(
                    value: cubit,
                    child: AddExitRecordScreen(stateDetails: state),
                  ),
                ),
              ).then((_) => cubit.clearNavigation());
            }
          },
          child: BlocBuilder<DetailsGroubCubit, DetailsGroubState>(
            builder: (context, state) {
              final cubit = context.read<DetailsGroubCubit>();
              return Scaffold(
                backgroundColor: AppColors.secondary,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () async {
                    final hasConnection = await checkConnection(context);
                    if (!hasConnection) return;
                    cubit.actionFAB();
                  },
                  backgroundColor: AppColors.primary,
                  label: Icon(
                    CupertinoIcons.person_add,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                body: Column(
                  children: [
                    TopSectionGroubDetails(groupDetails: widget.groupModel),
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
                            CustomSearchField(
                              controller: cubit.searchController,
                              onChanged: (val) {
                                cubit.searchMember(val);
                              },
                            ),
                            TabBar(
                              onTap: (index) {
                                cubit.updateIndex(index);
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
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  // ── تاب الأعضاء ──
                                  _buildRefreshableList(
                                    context,
                                    _buildMembersList(context, state),
                                  ),

                                  // ── تاب الزيارات مع الفلتر ──
                                  ValueListenableBuilder<VisitFilter>(
                                    valueListenable: _filterNotifier,
                                    builder: (context, filter, _) => Column(
                                      children: [
                                        VisitsFilterWidget(
                                          selected: filter,
                                          onChanged: (f) =>
                                              _filterNotifier.value = f,
                                        ),
                                        Expanded(
                                          child: _buildRefreshableList(
                                            context,
                                            _buildVisitsList(
                                              context,
                                              state,
                                              filter,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ── تاب الخروج ──
                                  _buildRefreshableList(
                                    context,
                                    _buildKhrojList(context, state),
                                  ),
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

  Widget _buildRefreshableList(BuildContext context, Widget child) {
    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: () async {
        await context.read<DetailsGroubCubit>().fetchMembers();
      },
      child: child,
    );
  }

  Widget _buildMembersList(BuildContext context, DetailsGroubState state) {
    if (state.members.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 200.h),
          const BuildEmptyState(),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: state.members.length,
      itemBuilder: (context, index) {
        final cubit = context.read<DetailsGroubCubit>();
        final member = state.members[index];

        return MemberCard(
          detailsGroubCubit: cubit,
          membersData: member,
          currentRoute: state.navigateTo,
          onTap: () => cubit.toggleKhareg(member),
          editFuncation: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AddMemberScreen(detailsGroubCubit: cubit, member: member),
              ),
            );
          },
          deleteFuncation: () {
            if (member.id != null) {
              AddMemberCubit(detailsGroubCubit: cubit)
                ..removeMember(member.id!)
                ..close();
            }
          },
          groupModel: widget.groupModel,
        );
      },
    );
  }

  Widget _buildVisitsList(
    BuildContext context,
    DetailsGroubState state,
    VisitFilter filter,
  ) {
    // فلترة الأعضاء اللي عندهم زيارات فقط
    final List<MembersModel> membersWithVisits = state.members
        .where(
          (member) =>
              member.allTimeVisted != null && member.allTimeVisted!.isNotEmpty,
        )
        .toList();

    if (membersWithVisits.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 200.h),
          const BuildEmptyState(note: "لا توجد زيارات"),
        ],
      );
    }

    // ترتيب حسب الفلتر المختار
    final sorted = sortMembersByFilter(membersWithVisits, filter);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final cubit = context.read<DetailsGroubCubit>();
        final member = sorted[index];

        return MemberCard(
          detailsGroubCubit: cubit,
          membersData: member,
          currentRoute: state.navigateTo,
          onTap: () => cubit.toggleKhareg(member),
          editFuncation: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AddMemberScreen(detailsGroubCubit: cubit, member: member),
              ),
            );
          },
          deleteFuncation: () {
            if (member.id != null) {
              AddMemberCubit(detailsGroubCubit: cubit)
                ..removeMember(member.id!)
                ..close();
            }
          },
          groupModel: widget.groupModel,
        );
      },
    );
  }

  Widget _buildKhrojList(BuildContext context, DetailsGroubState state) {
    final List<Map<String, dynamic>> allExitRecords = [];

    for (var member in state.members) {
      if (member.allTimeKhroug != null) {
        for (var exitDate in member.allTimeKhroug!) {
          allExitRecords.add({'member': member, 'exitDate': exitDate});
        }
      }
    }

    if (allExitRecords.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 200.h),
          const BuildEmptyState(note: "لا يوجد سجل خروج"),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: allExitRecords.length,
      itemBuilder: (context, index) {
        final cubit = context.read<DetailsGroubCubit>();
        final member = allExitRecords[index]['member'] as MembersModel;

        return MemberCard(
          detailsGroubCubit: cubit,
          membersData: member,
          currentRoute: state.navigateTo,
          onTap: () => cubit.toggleKhareg(member),
          editFuncation: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AddMemberScreen(detailsGroubCubit: cubit, member: member),
              ),
            );
          },
          deleteFuncation: () {
            if (member.id != null) {
              AddMemberCubit(detailsGroubCubit: cubit)
                ..removeMember(member.id!)
                ..close();
            }
          },
          groupModel: widget.groupModel,
        );
      },
    );
  }
}

class BuildEmptyState extends StatelessWidget {
  const BuildEmptyState({super.key, this.widget, this.note});

  final Widget? widget;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.search, size: 50.sp, color: Colors.grey[400]),
          SizedBox(height: 10.h),
          Text(
            note ?? "لا يوجد أعضاء",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          widget ?? const SizedBox(),
        ],
      ),
    );
  }

  void showMemberDetailsBottomSheet(BuildContext context, MembersModel member) {
    // الألوان المستخدمة في التصميم الخاص بك
    const Color primaryColor = Color(
      0xFF1E888A,
    ); // اللون الخاص بالتطبيق (تقريبي من الصورة)
    const Color backgroundColor = Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // مهم جداً عشان لو البيانات كتير الشاشة تكبر مع السحب
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl, // لضمان عرض الواجهة باللغة العربية
          child: Container(
            height:
                MediaQuery.of(context).size.height * 0.75, // ياخد 75% من الشاشة
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // مؤشر السحب (Drag Indicator)
                const SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),

                // المحتوى القابل للتمرير
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الهيدر: الصورة + الاسم + العمر
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: member.photo.isNotEmpty
                                  ? NetworkImage(member.photo)
                                  : null,
                              child: member.photo.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${member.age} سنة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // التاجز (حالة الطالب، الجنس، إلخ)
                        Row(
                          children: [
                            _buildStatusBadge(
                              text: 'طالب',
                              isActive: member.isStudent,
                            ),
                            const SizedBox(width: 10),
                            _buildTag(
                              text: member.gender,
                              icon: Icons.transgender,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 10),
                            if (member.khareg)
                              _buildTag(
                                text: 'خروج',
                                icon: Icons.exit_to_app,
                                color: Colors.orange,
                              ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(),
                        ),

                        // بيانات التواصل
                        _buildSectionTitle(
                          'معلومات التواصل',
                          Icons.contact_phone_outlined,
                        ),
                        const SizedBox(height: 10),
                        _buildInfoCard(
                          children: [
                            _buildInfoRow(
                              Icons.phone_android,
                              'رقم الموبايل',
                              member.phone,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // البيانات الدراسية
                        _buildSectionTitle(
                          'البيانات الدراسية',
                          Icons.school_outlined,
                        ),
                        const SizedBox(height: 10),
                        _buildInfoCard(
                          children: [
                            _buildInfoRow(
                              Icons.account_balance,
                              'الجامعة',
                              member.university ?? 'غير محدد',
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Divider(),
                            ),
                            _buildInfoRow(
                              Icons.menu_book,
                              'الكلية',
                              member.faculty ?? 'غير محدد',
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Divider(),
                            ),
                            _buildInfoRow(
                              Icons.stairs,
                              'المستوى',
                              member.level ?? 'غير محدد',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // بيانات الزيارات
                        _buildSectionTitle('نشاط العضو', Icons.history),
                        const SizedBox(height: 10),
                        _buildInfoCard(
                          children: [
                            _buildInfoRow(
                              Icons.access_time,
                              'آخر زيارة',
                              member.lastVisted ?? 'غير معروف',
                              valueColor: primaryColor,
                            ),
                            if (member.lastKhroug != null) ...[
                              const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Divider(),
                              ),
                              _buildInfoRow(
                                Icons.time_to_leave,
                                'آخر خروج',
                                member.lastKhroug!,
                              ),
                            ],
                          ],
                        ),

                        // الملاحظات (تظهر فقط لو موجودة)
                        if (member.notes.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildSectionTitle('ملاحظات', Icons.notes),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              member.notes,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ),
                        ],

                        const SizedBox(height: 30), // مسافة فارغة في الأسفل
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // ويدجتس مساعدة (Helper Widgets) لترتيب الكود
  // ==========================================

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E888A), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E888A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({required String text, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isActive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
