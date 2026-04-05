import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExitRecordScreen extends StatelessWidget {
  const AddExitRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B7A7A),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'تسجيل خروج جديد',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'ID: FD89A',
              style: TextStyle(fontSize: 12.sp, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SearchSection(),
            SizedBox(height: 20.h),
            const PersonSelectionSection(),
            SizedBox(height: 20.h),
            const SectionTitle(title: 'مدة الخروج'),
            SizedBox(height: 10.h),
            const DurationSelectionSection(),
            SizedBox(height: 15.h),
            const ManualDateButton(),
            SizedBox(height: 20.h),
            const ToggleExitDateSection(),
            SizedBox(height: 10.h),
            const DateDisplayField(),
            SizedBox(height: 30.h),
            const ConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: '...بحث عن شخص بالاسم',
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

class PersonSelectionSection extends StatelessWidget {
  const PersonSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        PersonCard(
          name: 'أحمد أرج',
          imageUrl: 'https://i.ibb.co/TBVyJJzb/1.png',
          isSelected: false,
        ),
        // PersonCard(
        //   name: 'محمد علي',
        //   imageUrl: 'https://via.placeholder.com/150',
        //   isSelected: false,
        // ),
        // PersonCard(
        //   name: 'محمود علي',
        //   imageUrl: 'https://via.placeholder.com/150',
        //   isSelected: true,
        // ),
      ],
    );
  }
}

class PersonCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;

  const PersonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF1B7A7A) : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 30.r,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class DurationSelectionSection extends StatelessWidget {
  const DurationSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        DurationCard(label: '٤ شهور', isSelected: false),
        DurationCard(label: '٤٠ يوم', isSelected: false),
        DurationCard(label: '٣ أيام', isSelected: true),
      ],
    );
  }
}

class DurationCard extends StatelessWidget {
  final String label;
  final bool isSelected;

  const DurationCard({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1B7A7A) : const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ManualDateButton extends StatelessWidget {
  const ManualDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.calendar_month_outlined, color: Colors.grey),
          Text(
            'تحديد تاريخ يدوي',
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class ToggleExitDateSection extends StatelessWidget {
  const ToggleExitDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Switch(
          value: true,
          onChanged: (val) {},
          activeColor: const Color(0xFF1B7A7A),
        ),
        Text(
          'تحديد تاريخ الخروج؟',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class DateDisplayField extends StatelessWidget {
  const DateDisplayField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
          Text(
            '٢٤ أكتوبر ٢٠٢٣',
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B7A7A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: () {},
        child: Text(
          'تأكيد تسجيل الخروج',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
