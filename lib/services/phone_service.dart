import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone_model.dart';

class PhoneService {
  static const String baseUrl = "https://resp-api-three.vercel.app";

  // Get All Data
  Future<List<Phone>> fetchPhones() async {
    final response = await http.get(Uri.parse('$baseUrl/phones'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((json) => Phone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Get Detail Data
  Future<Phone> fetchDetailPhone(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/phone/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final data = decoded['data'];

      return Phone.fromJson(data);
    } else {
      throw Exception('Failed to load data detail');
    }
  }

  // Create Data
  Future<bool> createPhone({
    required String name,
    required String brand,
    required String price,
    required String specification,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phone'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'brand': brand,
        'price': price,
        'specification': specification,
      }),
    );
    return response.statusCode == 201;
  }

  // Update Data
  Future<bool> updatePhone({
    required int id,
    required String name,
    required String brand,
    required String price,
    required String specification,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/phone/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'brand': brand,
        'price': price,
        'specification': specification,
      }),
    );
    return response.statusCode == 200;
  }

  // Delete Data
  Future<bool> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phone/$id'));
    return response.statusCode == 200;
  }
}
