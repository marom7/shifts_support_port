import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('employyes');

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14,
    ).animate(animationController);
    super.onInit();
  }

  void login() {
    final phone = phoneController.text;
    final password = passwordController.text;
    signIn();
    // ignore: avoid_print
    print('Login with $phone and $password');
    // כאן תוכל לקרוא ל־Firebase או להוסיף ניווט
    if (phone.isNotEmpty && password.isNotEmpty) {
      // הוספת לוגיקה לכניסה למערכת
      if (phone == '050' && password == '0000') {
        // הוספת ניווט למסך הבית
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
      Get.snackbar('Success', 'Logged in successfully');
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'marom7@gmail.com',
        password: 'mm2807',
      );
      // הצלחה
      if (kDebugMode) {
        print('התחברות הצליחה');
      }
    } on FirebaseAuthException catch (e) {
      //setState(() {
      if (kDebugMode) {
        print(e.message ?? 'שגיאה לא ידועה');
      }
      //});
    }
  }
}
