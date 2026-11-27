import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/moneda.dart';
import '../models/cambio.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080';

  // 1. Login
  Future<String?> login(String usuario, String clave) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/usuarios/login/$usuario/$clave'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; 
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  // 2. Listar Monedas
  Future<List<Moneda>> listarMonedas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/monedas'),
        headers: {
          'Authorization': 'Bearer $token', // <-- Con la palabra Bearer
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Moneda.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error al listar monedas: $e');
      return [];
    }
  }

  // 3. Listar Cambios por Periodo
  Future<List<Cambio>> listarCambiosPorPeriodo(String token, int idMoneda, String desde, String hasta) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/monedas/cambiosporperiodo'),
        headers: {
          'Authorization': 'Bearer $token', // <-- Con la palabra Bearer
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idMoneda': idMoneda,
          'desde': desde,
          'hasta': hasta,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Cambio.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error al listar cambios: $e');
      return [];
    }
  }
}