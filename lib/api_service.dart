import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<dynamic>> fetchUsers() async {
    final res = await http.get(Uri.parse('$_baseUrl/users'));
    if (res.statusCode == 200) return jsonDecode(res.body) as List<dynamic>;
    throw Exception('Error fetching users: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> fetchUser(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/users/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Error fetching user: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode == 201 || res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Error creating user: ${res.statusCode}');
  }

  static Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> payload) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Error updating user: ${res.statusCode}');
  }

  static Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/users/$id'));
    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception('Error deleting user: ${res.statusCode}');
  }
}
