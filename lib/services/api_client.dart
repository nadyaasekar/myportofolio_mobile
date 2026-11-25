import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<List<Experience>> getExperiences() async {
    final response = await _client
        .get(
          _uri('/api/v1/experiences/'),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 20));

    _ensureSuccess(response);

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return data
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client
        .post(
          _uri('/api/v1/experiences/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(experience.toJson()),
        )
        .timeout(const Duration(seconds: 20));

    _ensureSuccess(response);

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return Experience.fromJson(data);
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client
        .post(
          _uri('/api/v1/auth/token/'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(const Duration(seconds: 20));

    _ensureSuccess(response);

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    return data['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client
        .post(
          _uri('/api/v1/auth/logout/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        )
        .timeout(const Duration(seconds: 20));

    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    String message;

    switch (response.statusCode) {
      case 400:
        message = 'Data tidak valid. Periksa kembali isianmu.';
        break;
      case 401:
        message = 'Sesi tidak valid. Silakan login kembali.';
        break;
      case 403:
        message = 'Akunmu tidak memiliki izin untuk melakukan tindakan ini.';
        break;
      case 404:
        message = 'Data atau alamat API tidak ditemukan.';
        break;
      default:
        message = 'Permintaan gagal. Silakan coba lagi.';
    }

    // Gunakan pesan validasi JSON dari DRF, bukan halaman error HTML.
    if (response.statusCode == 400) {
      try {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data is Map<String, dynamic>) {
          final messages = data.entries
              .map((entry) {
                final value = entry.value;
                final text = value is List
                    ? value.join(', ')
                    : value.toString();

                return '${entry.key}: $text';
              })
              .join('\n');

          if (messages.isNotEmpty) {
            message = messages;
          }
        }
      } on FormatException {
        // Pertahankan pesan umum jika respons bukan JSON.
      }
    }

    throw ApiException(response.statusCode, message);
  }

  void close() {
    _client.close();
  }
}
