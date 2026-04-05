import 'package:fe_sabel_allah/screens/add_member/add_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import 'widgets/5rog_card.dart';
import 'widgets/custom_search_field.dart';
import 'widgets/member_card.dart';
import 'widgets/top_section_groub_details.dart';
import 'widgets/visits_card.dart'; // تأكد من مسار الملف الصحيح
// import 'widgets/member_card.dart'; // تأكد من استيراد الكارت الذي صممناه سابقاً

class DetailsGroubScreen extends StatelessWidget {
  const DetailsGroubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => AddMemberScreen()),
            );
          },
          tooltip: 'Add Member',
          backgroundColor: const Color(0xFF1D2D2D),
          label: Icon(Icons.person_add, color: Colors.white, size: 20.sp),
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
                    // شريط البحث
                    const CustomSearchField(),
                    // 2. شريط التبويبات (TabBar)
                    TabBar(
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

                    // 3. محتوى التبويبات (TabBarView)
                    Expanded(
                      child: TabBarView(
                        
                        children: [
                          _buildMembersList(),
                          _buildVisitsList(),
                          _buildKhrogsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: 15,
      itemBuilder: (context, index) {
        return MemberCard(photoNum: index + 1, onTap: () {});
      },
    );
  }

  Widget _buildVisitsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: 15,
      itemBuilder: (context, index) {
        return VisitsCard(photoNum: index + 1);
      },
    );
  }

  Widget _buildKhrogsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      itemCount: 15,
      itemBuilder: (context, index) {
        return KhrogCard(photoNum: index + 1);
      },
    );
  }
}
