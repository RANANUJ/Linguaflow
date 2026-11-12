
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../../../core/storage/local_storage_service.dart';

import '../../domain/models/user_model.dart';
import 'auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    http.Client? client,
    LocalStorageService? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? LocalStorageService();

  final http.Client _client;
  final LocalStorageService _storage;

  // NestJS backend URL.
  String get _baseUrl => ApiConfig.baseUrl;

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return _handleUserResponse(response);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = _decodeResponse(response);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final token = responseData['accessToken'];

      if (token is! String || token.isEmpty) {
        throw Exception('Login response did not contain an access token.');
      }

      // Save JWT token securely.
      await _storage.saveToken(token);

      final userData = responseData['user'];

      return UserModel(
        name: userData['name'] as String,
        email: userData['email'] as String,
      );
    }

    throw Exception(_getErrorMessage(responseData));
  }

  UserModel _handleUserResponse(http.Response response) {
    final responseData = _decodeResponse(response);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final userData = responseData['user'];

      return UserModel(
        name: userData['name'] as String,
        email: userData['email'] as String,
      );
    }

    throw Exception(_getErrorMessage(responseData));
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Invalid response from server.');
  }

  String _getErrorMessage(Map<String, dynamic> responseData) {
    String message = 'Something went wrong. Please try again.';

    final errorMessage = responseData['message'];

    if (errorMessage is String) {
      message = errorMessage;
    } else if (errorMessage is List) {
      message = errorMessage.join(', ');
    }

    return message;
  }

  @override
  Future<void> logout() async {
    // Remove the saved JWT token.
    await _storage.deleteToken();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Current-user restoration will be added
    // after creating a protected backend profile endpoint.
    return null;
  }
}
