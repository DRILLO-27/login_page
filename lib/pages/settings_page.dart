import 'package:flutter/material.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(
            context,
            icon: Icons.person,
            text: "Perfil",
            route: '/profile',
          ),
          _buildSettingItem(
            context,
            icon: Icons.lock,
            text: "Privacidad",
            info: "Tus datos están protegidos y no se comparten con terceros.",
          ),
          _buildSettingItem(
            context,
            icon: Icons.info,
            text: "Sobre nosotros",
            info:
                "Doctor Appointment App es una plataforma para agendar citas médicas fácilmente.",
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon, required String text, String? info, String? route}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(text),
        onTap: () {
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else if (info != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(text),
                content: Text(info),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar"),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
