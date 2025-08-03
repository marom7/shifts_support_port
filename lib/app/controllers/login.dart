import 'dart:convert'; // Import for Base64 encoding and decoding
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/controllers/employee.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('employyes');

  final EmployeeController controller = Get.put(EmployeeController());

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
    String phoneWorker; 
    
    signIn();
    // ignore: avoid_print
    print('Login with $phone and $password');
    // כאן תוכל לקרוא ל־Firebase או להוסיף ניווט
    if (phone.isNotEmpty && password.isNotEmpty) {
      // הוספת לוגיקה לכניסה למערכת
      for (var worker in controller.employees) {
        phoneWorker = worker.phone.split('-')[0]+ worker.phone.split('-')[1];
        if (phoneWorker == phone && worker.phone.split('-')[1] == password) {
          Get.offAllNamed('/home'); // Navigate to home page on successful login
          Get.snackbar('נכנסת בהצלחה', 'יום טוב לך ${worker.name}');
          return; // Exit after successful login
        }
      }
      if (phone == '050' && password == '00') { // דוגמה לבדיקה
        // הוספת ניווט למסך הבית
        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Logged in successfully');
        return;
      } else {
        Get.snackbar('שגיאה', 'פרטי התחברות שגויים');
        return;
      }
    }
    Get.snackbar('שגיאה', 'אנא למלא את כל השדות');
  }

  @override
  void onClose() {
    animationController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Function to encode a password
  String encodePassword(String password) {
    return base64Encode(utf8.encode(password));
  }

  /// Function to decode a password
  String decodePassword(String encodedPassword) {
    return utf8.decode(base64Decode(encodedPassword));
  }

  Future<void> signIn() async {
    try {
      final decodedPassword = decodePassword('bW0yODA3'); // Decode it back

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'marom7@gmail.com',
        password: decodedPassword, // Use the decoded password
      );
      // הצלחה
      if (kDebugMode) {
        print('התחברות הצליחה');
      }
    } on FirebaseAuthException catch (e) {
      //setState(() {
      if (kDebugMode) {
        print('${e.message} שגיאה בזיהוי FirebaseAuth ${e.code}');
      }
      //});
    }
  }
}
