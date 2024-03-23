import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/screens/admin_screen.dart';
import 'package:kylikeio/services/auth_service.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  Get.put<AuthService>(
    AuthService(),
    permanent: true,
  );
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
      locale: const Locale('el', 'GR'),
      themeMode: ThemeMode.system,
      initialRoute: '/',
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
