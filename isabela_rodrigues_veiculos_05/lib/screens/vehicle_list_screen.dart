import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';
import 'vehicle_edit_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Vehicle>> futureVehicles;

  @override
  void initState() {
    super.initState();
    futureVehicles = apiService.fetchVehicles();
  }

  void refreshVehicles() {
    setState(() {
      futureVehicles = apiService.fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Veículos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: FutureBuilder<List<Vehicle>>(
          future: futureVehicles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            final vehicles = snapshot.data!;

            return ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2E2E2E).withOpacity(0.40),
                        blurRadius: 5,
                        offset: Offset(8, 8),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: ListTile(
                            title: Text(
                              vehicle.model,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Marca: ${vehicle.brand}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Ano: ${vehicle.year}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VehicleEditScreen(
                                            vehicle: vehicle,
                                            refreshVehicles: refreshVehicles),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await apiService.deleteVehicle(vehicle.id);
                                    refreshVehicles();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VehicleEditScreen(refreshVehicles: refreshVehicles),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
