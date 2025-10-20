import 'package:flutter/material.dart';

class PrivacidadPage extends StatelessWidget {
  const PrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Política de Privacidad")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Tu información personal es confidencial y solo se usará con fines médicos y administrativos.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
