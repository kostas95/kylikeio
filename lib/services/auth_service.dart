import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already signed in when the app starts
    user = _auth.currentUser;
    // Listen for authentication state changes
    _auth.authStateChanges().listen((User? currentUser) {
      print(currentUser);
      print("car");
      user = currentUser;
      if (user != null) {
        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // print(credential);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('user_email', user.email ?? '');
    } catch (e) {
      print('Failed to sign in: $e');
      // Handle error
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      // this.user = null;
    } catch (e) {
      print('Failed to sign out: $e');
      // Handle error
    }
  }
}
