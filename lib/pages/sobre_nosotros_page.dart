import 'package:flutter/material.dart';

class SobreNosotrosPage extends StatelessWidget {
  const SobreNosotrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sobre Nosotros")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "DoctorAppointmentApp ayuda a conectar pacientes con médicos fácilmente y de manera segura.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
