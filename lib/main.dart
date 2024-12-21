import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/navigation_screen.dart';
import 'package:flutter_demo/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_demo/screens/register_screen.dart';
import 'firebase_options.dart'; // Import the generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Provide the options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expensees',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const NavigationScreen(), // Replace with your dashboard
      },
    );
  }
}