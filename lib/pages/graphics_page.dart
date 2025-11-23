import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphicsPage extends StatelessWidget {
  const GraphicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text(
          "Panel de Estadísticas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TÍTULO PRINCIPAL ---
            const Text(
              "Resumen General",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // --- CARD 1 (CITAS POR MES) ---
            _buildChartCard(
              title: "Citas creadas por mes",
              subtitle: "Datos simulados • Actualizado hoy",
              chart: _monthlyAppointmentsChart(),
            ),

            const SizedBox(height: 30),

            // --- CARD 2 (CITAS COMPLETADAS VS CANCELADAS) ---
            _buildChartCard(
              title: "Citas completadas vs canceladas",
              subtitle: "Desempeño general",
              chart: _completedVsCancelledChart(),
            ),

            const SizedBox(height: 30),

            // --- CARD 3 EXTRA: PACIENTES POR MÉDICO ---
            _buildChartCard(
              title: "Pacientes atendidos por médico",
              subtitle: "Top 5 especialistas",
              chart: _patientsPerDoctorChart(),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // =============== WIDGET TARJETA GENERAL ===============
  // =====================================================

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget chart,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.green.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.green.shade200, thickness: 1),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: chart),
        ],
      ),
    );
  }

  // =====================================================
  // ====================== GRÁFICA 1 =====================
  // =====================================================

  Widget _monthlyAppointmentsChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: true),
        maxY: 70,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, _) {
                const months = ["", "Ene", "Feb", "Mar", "Abr", "May"];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    months[val.toInt()],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _barGroup(1, 40),
          _barGroup(2, 55),
          _barGroup(3, 30),
          _barGroup(4, 62),
          _barGroup(5, 48),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) => BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            gradient: LinearGradient(
              colors: [
                Colors.green.shade400,
                Colors.green.shade800,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(8),
            width: 22,
          ),
        ],
      );

  // =====================================================
  // ====================== GRÁFICA 2 =====================
  // =====================================================

  Widget _completedVsCancelledChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            value: 78,
            title: "78%\nCompletadas",
            radius: 70,
            color: Colors.green.shade700,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          PieChartSectionData(
            value: 22,
            title: "22%\nCanceladas",
            radius: 65,
            color: Colors.red.shade400,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ====================== GRÁFICA 3 =====================
  // =====================================================

  Widget _patientsPerDoctorChart() {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(enabled: true),
        maxY: 40,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const doctors = ["", "Card.", "Ped.", "Derm.", "Dent.", "Nutri."];
                return Transform.rotate(
                  angle: -0.4,
                  child: Text(
                    doctors[value.toInt()],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _barGroup2(1, 32),
          _barGroup2(2, 25),
          _barGroup2(3, 18),
          _barGroup2(4, 28),
          _barGroup2(5, 35),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup2(int x, double y) => BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            width: 20,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade700,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      );
}
