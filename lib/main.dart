import 'package:chat_app/screens/phone_verification/sign_up_page.dart';
import 'package:chat_app/screens/views/Home_page.dart';
import 'package:chat_app/screens/views/login_screen.dart';
import 'package:chat_app/screens/views/splash_screen.dart';
import 'package:chat_app/utils/attributes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.Darktheme,
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => const login_Screen(),
        ),
        GetPage(
          name: "/HomePage",
          page: () => const HomePage(),
        ),GetPage(
          name: "/SingupPage",
          page: () => const SingupPage(),
        ),GetPage(
          name: "/spalsh_screen",
          page: () => const spalsh_screen(),
        ),
      ],
    ),
  );
}
