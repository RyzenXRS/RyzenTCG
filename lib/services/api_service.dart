import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/pokemon_card.dart';

class ApiService {
  // Base URL
  static const String baseUrl = 'https://task.itprojects.web.id';

  // Storage Bearer Token
  static const _storage = FlutterSecureStorage();

  // Token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Login
  static Future<bool> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': nim, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['data']['token'];
        await _storage.write(key: 'token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      print('Error Login: $e');
      return false;
    }
  }

  // GET Product
  static Future<List<PokemonCardModel>> fetchCards() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('Status Code GET: ${response.statusCode}');
      print('Response Body GET: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List productsJson = data['data']['products'];

        return productsJson
            .map((json) => PokemonCardModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error Fetching Cards: $e');
      return [];
    }
  }

  // POST Product
  static Future<bool> addCard(CardRequestModel card) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(card.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error Adding Card: $e');
      return false;
    }
  }

  // DELETE Product
  static Future<bool> deleteCard(int id) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error Deleting Card: $e');
      return false;
    }
  }

  // Submit
  static Future<bool> submitTask(SubmitTaskModel taskData) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(taskData.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error Submitting Task: $e');
      return false;
    }
  }
}
