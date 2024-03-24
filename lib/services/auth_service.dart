import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Failed to sign in: $e');
      // Handle error
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Failed to sign out: $e');
      // Handle error
    }
  }
}
