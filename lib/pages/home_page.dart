import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final user = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    if (index == 0) return;
    if (index == 1) Navigator.pushNamed(context, '/mensajes');
    if (index == 2) Navigator.pushNamed(context, '/configuracion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Appointment App"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, ${user?.email?.split('@').first ?? 'Usuario'}! 👋",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "¿En qué podemos ayudarte hoy?",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            // --- Botones principales ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mainOption(
                  icon: Icons.calendar_today,
                  text: "Agendar Cita",
                  color: Colors.green,
                  onTap: () {},
                ),
                _mainOption(
                  icon: Icons.healing,
                  text: "Consejos Médicos",
                  color: Colors.lightGreen,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),

            const Text(
              "Especialistas",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            _buildSpecialistList(),

            const SizedBox(height: 30),

            const Text(
              "Recomendaciones del día",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            _recommendationCard(
                "Mantén una buena hidratación y evita el exceso de cafeína."),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Mensajes"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configuración"),
        ],
      ),
    );
  }

  Widget _mainOption({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistList() {
    final specialists = [
      "Cardiólogo",
      "Pediatra",
      "Dermatólogo",
      "Dentista",
      "Nutriólogo"
    ];

    return Column(
      children: specialists
          .map(
            (e) => Card(
              child: ListTile(
                leading: const Icon(Icons.local_hospital, color: Colors.green),
                title: Text(e),
                subtitle: const Text("Disponible esta semana"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _recommendationCard(String text) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
