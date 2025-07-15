import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // כתום בהיר
      body: Center(
        child: Text(
          'מסך הגדרות',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
