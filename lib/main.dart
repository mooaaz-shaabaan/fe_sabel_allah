import 'package:fe_sabel_allah/firebase_options.dart';
import 'package:fe_sabel_allah/screens/add_%7Bexit_and_visits%7D_record_screen/add_exit_record_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 914),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Allah Akbar',
          theme: ThemeData(
            fontFamily: 'Tajawal',
            textTheme: Typography.englishLike2018.apply(
              fontSizeFactor: 1.sp,
              fontFamily: 'Tajawal',
            ),
          ),
          home: child,
        );
      },
      child: const AddExitRecordScreen(),
    );
  }
}


/*
  git add .
  git commit -m " ex.... "
  git push
*/