import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/screens/admin/widgets/products_screen.dart';
import 'package:kylikeio/screens/admin/widgets/sales_screen.dart';
import 'package:kylikeio/services/auth_service.dart';

import 'widgets/login_form.dart';

class AdminScreenController extends GetxController {
  final RxString index = "0".obs;
}

class AdminScreen extends StatelessWidget {
  const AdminScreen();

  @override
  Widget build(BuildContext context) {
    final AdminScreenController _controller = Get.put<AdminScreenController>(AdminScreenController());
    return Obx(() {
      if (Get.find<AuthService>().isLoggedIn.value) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Admin Dashboard'),
            ),
            actions: [
              Tooltip(
                message: "Αρχική",
                child: IconButton(
                  padding: EdgeInsets.all(16),
                  color: Get.theme.primaryColor.withOpacity(0.7),
                  onPressed: () => Get.offAllNamed("/"),
                  icon: Icon(Icons.home),
                ),
              ),
              Tooltip(
                message: "Logout",
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    padding: EdgeInsets.all(16),
                    color: Get.theme.primaryColor.withOpacity(0.7),
                    onPressed: () {
                      Get.find<AuthService>().logout();
                    },
                  ),
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                      'assets/dyv_logo.png',
                    ),
                    height: 96,
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Πωλήσεις",
                    style: TextStyle(
                      fontSize: Get.theme.textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                  onPressed: () {
                    _controller.index.value = "0";
                  },
                ),
                MaterialButton(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Προϊόντα",
                    style: TextStyle(
                      fontSize: Get.theme.textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                  onPressed: () {
                    _controller.index.value = "1";
                  },
                )
              ],
            ),
          ),
          body: getBody(_controller.index.value),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Admin Login'),
          ),
          leading: IconButton(
            onPressed: () => Get.offAllNamed("/"),
            icon: Icon(Icons.home),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: Get.width * 0.5,
            child: LoginForm(),
          ),
        ),
      );
    });
  }

  Widget getBody(String index) {
    switch (index) {
      case "0":
        return SalesScreen();
      case "1":
        return ProductsScreen();
      default:
        return SalesScreen();
    }
  }
}
