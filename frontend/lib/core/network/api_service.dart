// api_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';
import '../constants/strings.dart';

class ApiService {
  final String baseUrl;
  final FlutterSecureStorage secureStorage;

  ApiService({
    required this.baseUrl,
    required this.secureStorage,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // Similar updates for post, put, delete methods...
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: json.encode(body),
        headers: await _getHeaders(),
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
      );
      return _processResponse(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    final decoded = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw ServerException(
        message: decoded['message'] ?? Strings.genericErrorMessage,
        code: response.statusCode,
      );
    }
  }
}
