import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/services/auth_service.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<AuthService>().isLoggedIn.value) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Admin Dashboard'),
            ),
            leading: IconButton(
              onPressed: () => Get.offAllNamed("/"),
              icon: Icon(Icons.home),
            ),
          ),
          body: Center(
            child: MaterialButton(
              hoverElevation: 0,
              elevation: 0,
              padding: EdgeInsets.all(16),
              color: Get.theme.primaryColor.withOpacity(0.7),
              onPressed: () {
                Get.find<AuthService>().logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
}

class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              hoverElevation: 0,
              elevation: 0,
              padding: EdgeInsets.all(16),
              color: Get.theme.primaryColor.withOpacity(0.7),
              onPressed: () {
                // Implement authentication logic here
                // For simplicity, let's just print the entered credentials
                String username = _usernameController.text;
                String password = _passwordController.text;
                print('Username: $username, Password: $password');

                Get.find<AuthService>().login(username, password);
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
