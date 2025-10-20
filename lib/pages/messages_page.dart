import 'package:flutter/material.dart';

class MensajesPage extends StatelessWidget {
  const MensajesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensajes"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "Aquí aparecerán tus mensajes próximamente 💬",
          style: TextStyle(fontSize: 18, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
