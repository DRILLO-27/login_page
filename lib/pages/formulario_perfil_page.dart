import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombre = TextEditingController();
    final TextEditingController edad = TextEditingController();
    final TextEditingController nacimiento = TextEditingController();
    final TextEditingController padecimientos = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil del Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nombre, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: edad, decoration: const InputDecoration(labelText: "Edad")),
            TextField(controller: nacimiento, decoration: const InputDecoration(labelText: "Lugar de Nacimiento")),
            TextField(
              controller: padecimientos,
              decoration: const InputDecoration(labelText: "Padecimientos"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Datos guardados correctamente."),
                ));
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
