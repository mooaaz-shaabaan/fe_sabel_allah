import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../logic/add_khrog_and_visit/add_khrog_and_visit_cubit.dart';
import '../../logic/add_khrog_and_visit/add_khrog_and_visit_state.dart';
import '../../logic/details_groub/details_groub_cubit.dart';
import '../../logic/details_groub/details_groub_state.dart';
import '../../model/groub_model.dart';
import 'widgets/custom_search_field_add_visit.dart';
import 'widgets/exit_duration_widget.dart';
import 'widgets/members_horizontal_list.dart';
import 'widgets/top_section_visits.dart';

class AddVisitRecordScreen extends StatelessWidget {
  const AddVisitRecordScreen({
    super.key,
    required this.stateDetails,
    required this.groupModel,
  });

  final DetailsGroubState stateDetails;
  final GroupModel groupModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // التعديل: نمرر الـ DetailsGroubCubit للـ AddKhrogCubit عند إنشائه
      create: (context) =>
          AddKhrogCubit(detailsGroubCubit: context.read<DetailsGroubCubit>()),
      child: BlocConsumer<AddKhrogCubit, AddKhrogState>(
        listener: (context, state) {},
        builder: (context, stateKhrog) {
          final AddKhrogCubit cubit = context.read<AddKhrogCubit>();
          final DetailsGroubCubit detailsCubit = context
              .read<DetailsGroubCubit>();

          return Scaffold(
            backgroundColor: AppColors.secondary,
            body: Column(
              children: [
                const TopSectionVisits(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSearchFieldAddVisit(
                              searchController: detailsCubit.searchController,
                              onChanged: (val) {
                                detailsCubit.searchMember(val);
                              },
                            ),
                            SizedBox(height: 20.h),
                            MembersHorizontalList(
                              members: stateKhrog.members,
                              selectedMemberIndex:
                                  stateKhrog.selectedMemberIndex,
                              onMemberTap: (index) {
                                cubit.selectMember(index);
                              },
                            ),
                            SizedBox(height: 15.h),
                            ExitDurationWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
