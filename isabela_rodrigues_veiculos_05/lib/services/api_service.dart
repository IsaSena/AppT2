import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class ApiService {
  final String baseUrl = 'http://103.101.1.103:8080/vehicles';

  Future<List<Vehicle>> fetchVehicles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Resposta da API: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Lista de veículos: $jsonData');

        // Mapeia cada item para uma instância de Vehicle
        return jsonData.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        print('Erro ao buscar veículos: ${response.statusCode} - ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar veículos: $e');
      return [];
    }
  }

  Future<bool> createVehicle(Vehicle vehicle) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(vehicle.toJson()),
      );

      if (response.statusCode == 201) { // Status 201 para criação bem-sucedida
        print('Veículo criado com sucesso.');
        return true;
      } else {
        print('Erro ao criar veículo: ${response.statusCode} - ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar veículo: $e');
      return false;
    }
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${vehicle.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(vehicle.toJson()),
      );

      if (response.statusCode == 200) { // Status 200 para atualização bem-sucedida
        print('Veículo atualizado com sucesso.');
        return true;
      } else {
        print('Erro ao atualizar veículo: ${response.statusCode} - ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar veículo: $e');
      return false;
    }
  }

  Future<bool> deleteVehicle(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) { // Status 200 para exclusão bem-sucedida
        print('Veículo excluído com sucesso.');
        return true;
      } else {
        print('Erro ao excluir veículo: ${response.statusCode} - ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Erro ao excluir veículo: $e');
      return false;
    }
  }
}
