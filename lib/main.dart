import 'package:fe_sabel_allah/firebase_options.dart';
import 'package:fe_sabel_allah/screens/login/loginScreen.dart';
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
              textDirection: TextDirection.rtl, // هنا بنجبره يبدأ من اليمين
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
      child: const Loginscreen(),
    );
  }
}


/*
  git add .
  git commit -m " ex.... "
  git push
*/