import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _pacienteController = TextEditingController();

  final CollectionReference citas =
      FirebaseFirestore.instance.collection('citas');

  String? _selectedCitaId;

  Future<void> _agregarCita() async {
    await citas.add({
      'motivo': _motivoController.text,
      'doctor': _doctorController.text,
      'paciente': _pacienteController.text,
      'fecha': DateTime.now(),
    });
    _limpiarCampos();
  }

  Future<void> _actualizarCita(String id) async {
    await citas.doc(id).update({
      'motivo': _motivoController.text,
      'doctor': _doctorController.text,
      'paciente': _pacienteController.text,
    });
    _limpiarCampos();
  }

  Future<void> _eliminarCita(String id) async {
    await citas.doc(id).delete();
  }

  void _limpiarCampos() {
    _motivoController.clear();
    _doctorController.clear();
    _pacienteController.clear();
    _selectedCitaId = null;
  }

  void _mostrarFormulario(BuildContext context, {bool esEdicion = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              esEdicion ? 'Actualizar Cita' : 'Agendar Nueva Cita',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _doctorController,
              decoration: const InputDecoration(
                labelText: 'Doctor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pacienteController,
              decoration: const InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(esEdicion ? 'Actualizar Cita' : 'Guardar Cita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                if (esEdicion && _selectedCitaId != null) {
                  _actualizarCita(_selectedCitaId!);
                } else {
                  _agregarCita();
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Citas Médicas'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón Agendar Cita
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Agendar Cita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _mostrarFormulario(context),
                  ),
                ),
                const SizedBox(width: 16),
                // Botón Consejos Médicos
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.medical_services_outlined),
                    label: const Text('Consejos Médicos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Recuerda beber agua, dormir bien y hacer ejercicio regularmente 💪',
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Citas registradas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: citas.orderBy('fecha', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar las citas'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.docs;

                if (data.isEmpty) {
                  return const Center(child: Text('No hay citas registradas'));
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final doc = data[index];
                    final cita = doc.data() as Map<String, dynamic>;
                    final fecha = (cita['fecha'] as Timestamp).toDate();

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(cita['motivo']),
                        subtitle: Text(
                            'Dr. ${cita['doctor']} — Paciente: ${cita['paciente']}\n${fecha.toLocal()}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () {
                                setState(() {
                                  _selectedCitaId = doc.id;
                                  _motivoController.text = cita['motivo'];
                                  _doctorController.text = cita['doctor'];
                                  _pacienteController.text = cita['paciente'];
                                });
                                _mostrarFormulario(context, esEdicion: true);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarCita(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
