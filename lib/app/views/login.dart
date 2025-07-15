import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login.dart';
import '../views/widgets/wave_clipper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Directionality(
      textDirection: TextDirection.rtl, // יישור כללי לימין
      child: Scaffold(
        body: AnimatedBuilder(
          animation: controller.animation,
          builder: (context, child) {
            return Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(controller.animation.value),
                  child: Container(
                    height: 300,
                    color: Colors.blue.shade700,
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Text(
                        'תמיכה -ניהול משמרות'  ,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 220),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.phoneController,
                              textAlign: TextAlign.right, // יישור לימין
                              decoration: const InputDecoration(
                                labelText: 'נייד',
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller.passwordController,
                              obscureText: true,
                              textAlign: TextAlign.right, // יישור לימין
                              decoration: const InputDecoration(
                                labelText: 'סיסמא',
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            /*
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot password?'),
                              ),
                            ),*/
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 12),
                            /*
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: const Text('Sign Up'),
                            ),
                          */
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
