import 'package:flutter/material.dart';
import 'package:isabela_rodrigues_veiculos_05/db_connection/db_connection.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class VehicleEditScreen extends StatefulWidget {
  final Vehicle? vehicle;
  final Function refreshVehicles;

  const VehicleEditScreen(
      {super.key, this.vehicle, required this.refreshVehicles});

  @override
  _VehicleEditScreenState createState() => _VehicleEditScreenState();
}

class _VehicleEditScreenState extends State<VehicleEditScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late String model;
  late String brand;
  late int year;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      model = widget.vehicle!.model;
      brand = widget.vehicle!.brand;
      year = widget.vehicle!.year;
    } else {
      model = '';
      brand = '';
      year = DateTime.now().year; // Ano padrão
    }
  }

  void saveVehicle() async {
    final db = DatabaseConnection();
    if (_formKey.currentState!.validate()) {
      await db.openConnection();
      final vehicle = Vehicle(
        id: widget.vehicle?.id ?? '', //id normal ou id gerado pela API
        model: model,
        brand: brand,
        year: year,
      );

      if (widget.vehicle != null) {
        await apiService.updateVehicle(vehicle);
        // await db.connection.query(
        //   'UPSERT INTO vehicles (id, model, brand, year) VALUES (${vehicle.id}, ${vehicle.model}, ${vehicle.brand}, ${vehicle.year})',
        //   // substitutionValues: {
        //   //   'make': 'Toyota',
        //   //   'model': 'Corolla',
        //   //   'year': 2020,
        //   //   'price': 20000.00,
        //   // },
        // WHERE id = ${vehicles.id}
        // );
      } else {
        await apiService.createVehicle(vehicle);
        await db.connection.query(
          'INSERT INTO vehicles (id, model, brand, year) VALUES (${vehicle.id}, ${vehicle.model}, ${vehicle.brand}, ${vehicle.year})',
        );
      }
      setState(() {});
      await db.closeConnection();
      await widget.refreshVehicles();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicle != null ? 'Editar Veículo' : 'Adicionar Veículo',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: model,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  onChanged: (value) => model = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um modelo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: brand,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  onChanged: (value) => brand = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma marca';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: year.toString(),
                  decoration: const InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => year = int.tryParse(value) ?? 2024,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um ano';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => saveVehicle(),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
