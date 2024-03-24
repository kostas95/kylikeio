import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kylikeio/services/auth_service.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: "admin@admin.com");
  final TextEditingController _passwordController = TextEditingController(text: "1qaz@WSX");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onFieldSubmitted: (v) async {
                  if (v.isNotEmpty) await submit();
                },
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                hoverElevation: 0,
                elevation: 0,
                padding: EdgeInsets.all(16),
                color: Get.theme.primaryColor.withOpacity(0.7),
                onPressed: () async {
                  await submit();
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
      ),
    );
  }

  submit() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    await Get.find<AuthService>().login(username, password);
  }
}