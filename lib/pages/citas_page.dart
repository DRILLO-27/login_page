import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final CollectionReference citas =
      FirebaseFirestore.instance.collection('citas');

  final TextEditingController motivoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController horaFinController = TextEditingController();
  final TextEditingController pacienteController = TextEditingController();
  final TextEditingController medicoController = TextEditingController();

  // Función para crear o actualizar cita
  Future<void> _crearOActualizar([DocumentSnapshot? documentSnapshot]) async {
    String accion = 'crear';
    if (documentSnapshot != null) {
      accion = 'actualizar';
      motivoController.text = documentSnapshot['motivo'];
      fechaController.text = documentSnapshot['fecha'];
      horaInicioController.text = documentSnapshot['horaInicio'];
      horaFinController.text = documentSnapshot['horaFin'];
      pacienteController.text = documentSnapshot['paciente'];
      medicoController.text = documentSnapshot['medico'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: motivoController,
                  decoration: const InputDecoration(labelText: 'Motivo de la cita'),
                ),
                TextField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha (DD/MM/AAAA)'),
                ),
                TextField(
                  controller: horaInicioController,
                  decoration: const InputDecoration(labelText: 'Hora de inicio'),
                ),
                TextField(
                  controller: horaFinController,
                  decoration: const InputDecoration(labelText: 'Hora de fin'),
                ),
                TextField(
                  controller: pacienteController,
                  decoration: const InputDecoration(labelText: 'Paciente'),
                ),
                TextField(
                  controller: medicoController,
                  decoration: const InputDecoration(labelText: 'Médico'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(accion == 'crear' ? 'Crear cita' : 'Actualizar cita'),
                  onPressed: () async {
                    final String motivo = motivoController.text;
                    final String fecha = fechaController.text;
                    final String horaInicio = horaInicioController.text;
                    final String horaFin = horaFinController.text;
                    final String paciente = pacienteController.text;
                    final String medico = medicoController.text;

                    if (motivo.isNotEmpty &&
                        fecha.isNotEmpty &&
                        horaInicio.isNotEmpty &&
                        horaFin.isNotEmpty &&
                        paciente.isNotEmpty &&
                        medico.isNotEmpty) {
                      if (accion == 'crear') {
                        await citas.add({
                          "motivo": motivo,
                          "fecha": fecha,
                          "horaInicio": horaInicio,
                          "horaFin": horaFin,
                          "paciente": paciente,
                          "medico": medico,
                          "creadoEn": Timestamp.now(),
                        });
                      }

                      if (accion == 'actualizar') {
                        await citas.doc(documentSnapshot!.id).update({
                          "motivo": motivo,
                          "fecha": fecha,
                          "horaInicio": horaInicio,
                          "horaFin": horaFin,
                          "paciente": paciente,
                          "medico": medico,
                        });
                      }

                      motivoController.clear();
                      fechaController.clear();
                      horaInicioController.clear();
                      horaFinController.clear();
                      pacienteController.clear();
                      medicoController.clear();

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Función para eliminar cita
  Future<void> _eliminarCita(String citaId) async {
    await citas.doc(citaId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cita eliminada exitosamente.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Gestión de Citas',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 2,
      ),
      body: StreamBuilder(
        stream: citas.orderBy('creadoEn', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay citas registradas.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final citasDocs = streamSnapshot.data!.docs;

          return ListView.builder(
            itemCount: citasDocs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = citasDocs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.calendar_month, color: Colors.green),
                  title: Text(
                    documentSnapshot['motivo'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Text(
                    '📅 ${documentSnapshot['fecha']} | 🕒 ${documentSnapshot['horaInicio']} - ${documentSnapshot['horaFin']}\n👨‍⚕️ ${documentSnapshot['medico']}',
                  ),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _crearOActualizar(documentSnapshot),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _eliminarCita(documentSnapshot.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _crearOActualizar(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
