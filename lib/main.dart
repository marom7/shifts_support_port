            /* This is the main entry point of the application.
 It initializes Firebase and sets up the GetMaterialApp with routes and themes.
 The app starts with the LoginScreen and has a HomeScreen as well.
 The theme is customized with specific colors and Google Fonts.
 The app uses GetX for state management and routing.
 The main function ensures that Firebase is initialized before the app runs.
 The app uses Google Fonts for a consistent typography style.
 The primary color is set to a light blue, with an orange secondary color.
 The app bar is styled with a custom background color and title text style.
 The text theme is set to use the Assistant font from Google Fonts.
 The app is structured to allow easy navigation between the login and home screens using GetX.
 The app is designed to be responsive and visually appealing with a modern UI.
 The use of GetX allows for efficient state management and dependency injection.
 The app is ready to be extended with more features and functionalities as needed.
 The main.dart file serves as the entry point for the Flutter application.
 It sets up the necessary configurations and initializes Firebase.
 The app uses GetX for routing and state management, making it easy to navigate between screens.

GetX Architecture:
------------------
lib/
├── main.dart
├── app/
│   ├── controllers/shift_controller.dart
│   ├── models/shift_model.dart
│   ├── pages/shift_page.dart
│   └──| widgets/
│      ├── capsule_day_picker.dart
│      ├── shift_card.dart
│      └── dropdown_row.dart
└── firebase_options.dart
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // הוסף שורה זו
import 'app/views/home.dart';
import 'app/views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // הוסף שורה זו
  );

  runApp(
    GetMaterialApp(
      locale: const Locale('he'), // עברית
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF00ACC1), // תכלת
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFA726), // כתום
          primary: const Color(0xFF1976D2), // כחול
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF00ACC1), // תכלת
          titleTextStyle: GoogleFonts.assistant(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.assistantTextTheme(),
      ),
    ),
  );
}
