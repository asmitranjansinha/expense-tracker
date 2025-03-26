import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';
import '../constants/strings.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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
