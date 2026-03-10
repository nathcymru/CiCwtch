import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'api_exception.dart';

class ApiClient {
  ApiClient({required this.baseUrl, this.bearerToken});

  final String baseUrl;
  final String? bearerToken;

  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> get _headers {
    final token = bearerToken?.trim() ?? '';
    if (token.isEmpty) {
      return Map<String, String>.from(_defaultHeaders);
    }

    return {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _decode(response);
  }

  Map<String, String> get _authHeaders {
    final token = bearerToken?.trim() ?? '';
    if (token.isEmpty) return {};
    return {'Authorization': 'Bearer $token'};
  }

  Future<dynamic> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    required String fileField,
    required Uint8List fileBytes,
    required String filename,
    String? mimeType,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_authHeaders);
    request.fields.addAll(fields);
    request.files.add(
      http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: filename,
        contentType: mimeType != null
            ? _parseMediaType(mimeType)
            : null,
      ),
    );
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _decode(response);
  }

  static MediaType? _parseMediaType(String mimeType) {
    final parts = mimeType.split('/');
    if (parts.length == 2) {
      return MediaType(parts[0], parts[1]);
    }
    return null;
  }

  dynamic _decode(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return null;
      return jsonDecode(body);
    }

    String message = 'Request failed';
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final error = decoded['error'];
      if (error is Map<String, dynamic>) {
        message = (error['message'] as String?) ?? message;
      }
    } catch (_) {
      // fall through with default message
    }

    throw ApiException(statusCode: statusCode, message: message);
  }
}
