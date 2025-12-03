import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Tus imports de páginas
import 'package:login_page/pages/graphics_page.dart';
import 'package:login_page/pages/doctor_dashboard_page.dart';
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
      // --- LÓGICA DE ACCESO ---
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Si está cargando o no hay usuario -> Login
          if (!snapshot.hasData) {
            return const LoginPage();
          }

          // 2. Obtenemos el usuario actual
          final user = snapshot.data!;

          // 3. VERIFICACIÓN MANUAL DE ADMIN/DOCTOR
          // ¡¡CAMBIA 'admin@correo.com' POR TU CORREO REAL!!
          if (user.email == 'admin@correo.com') { 
            return const DoctorDashboardPage(); // <--- Entra aquí si es el Doctor
          }

          // 4. Si es cualquier otro correo -> Home de Paciente
          return const HomePage(); 
        },
      ),
      // ------------------------
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/mensajes': (context) => const MensajesPage(),
        '/configuracion': (context) => const ConfiguracionPage(),
        '/login': (context) => const LoginPage(),
        '/citas': (context) => const CitasPage(), 
        '/doctor_home': (context) => const DoctorDashboardPage(),
        '/graficas': (context) => const GraphicsPage(),
      },
    );
  }
}