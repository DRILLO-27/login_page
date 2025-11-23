import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/pages/graphics_page.dart';
import 'firebase_options.dart';

import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/messages_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';
import 'pages/citas_page.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/mensajes': (context) => const MensajesPage(),
        '/configuracion': (context) => const ConfiguracionPage(),
        '/login': (context) => const LoginPage(),
        '/citas': (context) => const CitasPage(), 
        '/graficas': (context) => const GraphicsPage(),
      },
    );
  }
}
