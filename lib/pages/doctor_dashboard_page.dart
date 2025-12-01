// lib/pages/doctor_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorDashboardPage extends StatelessWidget {
  const DoctorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario para mostrar su nombre o correo
    final user = FirebaseAuth.instance.currentUser;
    final String doctorName = user?.email?.split('@')[0] ?? "Doctor";

    return Scaffold(
      backgroundColor: Colors.green.shade50, // Fondo suave consistente con la app
      body: Column(
        children: [
          // --- HEADER PERSONALIZADO ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // Verde médico degradado
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panel Médico',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Hola, $doctorName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Botón de Logout estilizado
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ),
                ),
              ],
            ),
          ),

          // --- GRID DE OPCIONES ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9, // Hace las tarjetas un poco más altas
                children: [
                  // 1. TARJETA DE GRÁFICAS (La principal)
                  _DashboardCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Estadísticas',
                    subtitle: 'Ver métricas',
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/graficas');
                    },
                  ),
                  
                  // 2. TARJETA DE CITAS
                  _DashboardCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Mis Citas',
                    subtitle: 'Gestionar agenda',
                    color: Colors.blueAccent,
                    onTap: () {
                      // Navigator.pushNamed(context, '/gestion_citas');
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Próximamente: Gestión de Citas")));
                    },
                  ),

                  // 3. TARJETA DE PACIENTES (Relleno visual)
                  _DashboardCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Pacientes',
                    subtitle: 'Historiales',
                    color: Colors.orangeAccent,
                    onTap: () {},
                  ),

                  // 4. TARJETA DE NOTIFICACIONES (Relleno visual)
                  _DashboardCard(
                    icon: Icons.notifications_active_rounded,
                    title: 'Avisos',
                    subtitle: '3 nuevos',
                    color: Colors.redAccent,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET DE TARJETA MEJORADO ---
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono con fondo circular suave
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}