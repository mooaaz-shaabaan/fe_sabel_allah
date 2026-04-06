import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'logic/login_signup/login_signup_cubit.dart';
import 'logic/user/user_cubit.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_signup/login_screen.dart';
import 'shared/hive_helper.dart';
import 'shared/user_local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => LoginSignupCubit(userCubit: UserCubit())),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411, 914),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Allah Akbar',
            theme: ThemeData(
              fontFamily: 'Tajawal',
              textTheme: Typography.englishLike2018.apply(
                fontSizeFactor: 1.sp,
                fontFamily: 'Tajawal',
              ),
            ),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            home: child,
          );
        },
        child: AuthWrapper(),
      ),
    );
  }
}

//
//
// Check if user is logged in
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserLocalStorage.getUser();

    if (user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}


/* 
  flutter clean 
  flutter pub get
  flutter build apk --split-per-abi --release
  flutter build apk --release

*/