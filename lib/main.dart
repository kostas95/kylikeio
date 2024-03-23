import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/screens/admin_screen.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ΚΥΛΙΚΕΙΟ ΔΥΒ',
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(
          name: '/',
          page: () => MainScreen(),
        ),
        GetPage(
          name: '/admin',
          page: () => AdminScreen(),
        ),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: EnvironmentVariables.primaryColor,
          secondary: EnvironmentVariables.secondaryColor,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class EnvironmentVariables {
  static final Color primaryColor = const Color(0xFF70ffd2);
  static final Color secondaryColor = const Color(0xFFFFFF);
}
