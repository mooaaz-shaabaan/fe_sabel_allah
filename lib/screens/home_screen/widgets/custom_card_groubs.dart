import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../model/groub_model.dart';
import '../../../shared/user_local_storage.dart';
import '../../details_groub/details_groub_screen.dart';

class CustomCardGroubs extends StatelessWidget {
  const CustomCardGroubs({
    super.key,
    required this.groups,
    required this.onTap,
    this.isLoading = false,
  });

  final List<GroupModel> groups;
  final Function(GroupModel groupDetails) onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final myId = UserLocalStorage.getUser()?.id ?? '';

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 25.h, left: 15.w, right: 15.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: groups.isEmpty
            ? _buildEmptyState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مجموعاتى",
                    style: TextStyle(
                      fontSize: 30..sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                      itemCount: groups.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        bool isWaiting = group.waitingList.contains(myId);

                        return _buildCleanCard(group, isWaiting, context);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCleanCard(
    GroupModel group,
    bool isWaiting,
    BuildContext context,
  ) {
    return AbsorbPointer(
      absorbing: isWaiting,
      child: GestureDetector(
        onTap: () {
          // التعديل هنا: تمرير الموديل كاملاً
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => DetailsGroubScreen(groupModel: group),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isWaiting ? Colors.grey[50] : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isWaiting ? Colors.grey.shade200 : Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: isWaiting
                            ? Colors.grey.shade400
                            : const Color(0xFFA8C6A3),
                        child: Icon(
                          isWaiting
                              ? Icons.hourglass_top_rounded
                              : Icons.group_work_outlined,
                          color: Colors.white,
                          size: 35..sp,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: 18..sp,
                              fontWeight: FontWeight.bold,
                              color: isWaiting ? Colors.grey : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isWaiting
                                ? 'في انتظار الموافقة'
                                : '${(group.memberCount ?? 0) - group.waitingList.length} عضو',
                            style: TextStyle(
                              fontSize: 13..sp,
                              color: isWaiting
                                  ? Colors.orange.shade700
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 110.w,
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 4.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: isWaiting
                              ? Colors.grey[200]
                              : const Color(0xFFE8F5E9),
                        ),
                        child: Center(
                          child: Text(
                            'ID: ${group.groupCode}',
                            style: TextStyle(
                              fontSize: 12..sp,
                              fontWeight: FontWeight.w600,
                              color: isWaiting
                                  ? Colors.grey
                                  : Colors.green[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWaiting)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Icon(
                    Icons.access_time_filled_rounded,
                    color: Colors.orange,
                    size: 20..sp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isLoading
            ? [const CircularProgressIndicator(color: Color(0xFFA8C6A3))]
            : [
                Icon(
                  Icons.group_off_outlined,
                  size: 60..sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 15.h),
                Text(
                  'مفيش مجموعات لسه',
                  style: TextStyle(fontSize: 18..sp, color: Colors.grey[500]),
                ),
              ],
      ),
    );
  }
}
