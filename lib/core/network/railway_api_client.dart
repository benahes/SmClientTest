import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class RailwayApiClient {
  RailwayApiClient({
    http.Client? httpClient,
    FirebaseAuth? firebaseAuth,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _firebaseAuth = firebaseAuth,
        _baseUrl = (baseUrl ?? AppConfig.railwayApiBaseUrl).trim();

  final http.Client _httpClient;
  final FirebaseAuth? _firebaseAuth;
  final String _baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
    );
    return _decodeObject(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(
      method: 'POST',
      path: path,
      body: body,
      queryParameters: queryParameters,
    );
    return _decodeObject(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(
      method: 'PUT',
      path: path,
      body: body,
      queryParameters: queryParameters,
    );
    return _decodeObject(response);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(
      method: 'PATCH',
      path: path,
      body: body,
      queryParameters: queryParameters,
    );
    return _decodeObject(response);
  }

  Future<void> delete(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(
      method: 'DELETE',
      path: path,
      queryParameters: queryParameters,
    );
    _throwIfError(response);
  }

  Future<http.Response> _send({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    if (_baseUrl.isEmpty) {
      throw const ApiException(
        statusCode: 0,
        message: 'RAILWAY_API_BASE_URL is not configured.',
      );
    }

    final uri = _buildUri(path, queryParameters);
    final headers = await _headers();
    final encodedBody = body == null ? null : jsonEncode(body);

    final response = switch (method) {
      'GET' => await _httpClient.get(uri, headers: headers),
      'POST' =>
        await _httpClient.post(uri, headers: headers, body: encodedBody),
      'PUT' => await _httpClient.put(uri, headers: headers, body: encodedBody),
      'PATCH' =>
        await _httpClient.patch(uri, headers: headers, body: encodedBody),
      'DELETE' => await _httpClient.delete(uri, headers: headers),
      _ => throw ArgumentError('Unsupported HTTP method: $method'),
    };

    _throwIfError(response);
    return response;
  }

  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final normalizedBaseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBaseUrl$normalizedPath');
    return uri.replace(queryParameters: queryParameters ?? uri.queryParameters);
  }

  Future<Map<String, String>> _headers() async {
    final token = Firebase.apps.isEmpty
        ? null
        : await (_firebaseAuth ?? FirebaseAuth.instance)
            .currentUser
            ?.getIdToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeObject(http.Response response) {
    if (response.body.trim().isEmpty) return <String, dynamic>{};

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;

    return {'data': decoded};
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    Object? details;
    String message = 'Request failed.';

    try {
      details = jsonDecode(response.body);
      if (details is Map<String, dynamic>) {
        message = details['message']?.toString() ??
            details['error']?.toString() ??
            message;
      }
    } catch (_) {
      if (response.body.trim().isNotEmpty) {
        message = response.body.trim();
      }
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
      details: details,
    );
  }
}
