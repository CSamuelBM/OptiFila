import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl =
      'https://backi251-optifila-backend.hf.space/api/v1';

  final http.Client _client;

  ApiClient({http.Client? client})
      : _client = client ?? http.Client();

  /// =========================
  /// POST
  /// =========================
  Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// GET
  /// =========================
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? headers,
      }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );

    return _handleResponse(response);
  }

  /// =========================
  /// PUT
  /// =========================
  Future<Map<String, dynamic>> put(
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// DELETE
  /// =========================
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final request = http.Request(
      'DELETE',
      Uri.parse('$baseUrl$endpoint'),
    );

    request.headers.addAll({
      'Content-Type': 'application/json',
      ...?headers,
    });

    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  /// =========================
  /// RESPONSE HANDLER
  /// =========================
  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(
        decoded['message'] ?? 'Error en la petición',
      );
    }

    return decoded;
  }
}