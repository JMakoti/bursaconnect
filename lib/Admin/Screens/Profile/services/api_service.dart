import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'error_handler_service.dart';

// API Response Model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : json['data'],
      message: json['message'],
      statusCode: json['status_code'],
      errors: json['errors'],
    );
  }
}

// User Profile Model
class UserProfile {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      profileImageUrl: json['profile_image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Connected Account API Model
class ConnectedAccountModel {
  final String id;
  final String provider;
  final String accountId;
  final String email;
  final bool isActive;
  final DateTime connectedAt;

  ConnectedAccountModel({
    required this.id,
    required this.provider,
    required this.accountId,
    required this.email,
    required this.isActive,
    required this.connectedAt,
  });

  factory ConnectedAccountModel.fromJson(Map<String, dynamic> json) {
    return ConnectedAccountModel(
      id: json['id'],
      provider: json['provider'],
      accountId: json['account_id'],
      email: json['email'],
      isActive: json['is_active'],
      connectedAt: DateTime.parse(json['connected_at']),
    );
  }
}

// API Service Class
class ApiService {
  static const String baseUrl = 'https://api.yourapp.com/v1';
  static const Duration timeout = Duration(seconds: 30);

  // Headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_getAuthToken()}',
  };

  // Get auth token (implement your token storage logic)
  static String _getAuthToken() {
    // This would typically come from secure storage
    return 'your_auth_token_here';
  }

  // Generic GET request
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri = queryParams != null
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await http
          .get(finalUri, headers: _headers)
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw ErrorHandlerService.networkError('No internet connection');
    } on http.ClientException catch (e) {
      throw ErrorHandlerService.networkError('Network error: ${e.message}');
    } catch (e) {
      throw ErrorHandlerService.networkError('Request failed: $e');
    }
  }

  // Generic POST request
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw ErrorHandlerService.networkError('No internet connection');
    } on http.ClientException catch (e) {
      throw ErrorHandlerService.networkError('Network error: ${e.message}');
    } catch (e) {
      throw ErrorHandlerService.networkError('Request failed: $e');
    }
  }

  // Generic PUT request
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw ErrorHandlerService.networkError('No internet connection');
    } on http.ClientException catch (e) {
      throw ErrorHandlerService.networkError('Network error: ${e.message}');
    } catch (e) {
      throw ErrorHandlerService.networkError('Request failed: $e');
    }
  }

  // Generic DELETE request
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(uri, headers: _headers)
          .timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw ErrorHandlerService.networkError('No internet connection');
    } on http.ClientException catch (e) {
      throw ErrorHandlerService.networkError('Network error: ${e.message}');
    } catch (e) {
      throw ErrorHandlerService.networkError('Request failed: $e');
    }
  }

  // Handle HTTP response
  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>.fromJson(jsonData, fromJson);
      } else {
        throw ErrorHandlerService.networkError(
          jsonData['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } on FormatException {
      throw ErrorHandlerService.networkError(
        'Invalid response format',
        statusCode: response.statusCode,
      );
    }
  }

  // Profile API Methods
  static Future<UserProfile> getProfile() async {
    final response = await get<UserProfile>(
      '/profile',
      fromJson: UserProfile.fromJson,
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to fetch profile',
      );
    }
  }

  static Future<UserProfile> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    final response = await put<UserProfile>(
      '/profile',
      body: profileData,
      fromJson: UserProfile.fromJson,
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      if (response.errors != null) {
        throw ErrorHandlerService.validationError(
          response.message ?? 'Validation failed',
          fieldErrors: response.errors!.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        );
      } else {
        throw ErrorHandlerService.networkError(
          response.message ?? 'Failed to update profile',
        );
      }
    }
  }

  static Future<String> uploadProfileImage(String imagePath) async {
    try {
      final uri = Uri.parse('$baseUrl/profile/image');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_headers);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      final jsonData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonData['data']['image_url'];
      } else {
        throw ErrorHandlerService.networkError(
          jsonData['message'] ?? 'Failed to upload image',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ErrorHandlerService.networkError('No internet connection');
    } catch (e) {
      throw ErrorHandlerService.networkError('Image upload failed: $e');
    }
  }

  // Connected Accounts API Methods
  static Future<List<ConnectedAccountModel>> getConnectedAccounts() async {
    final response = await get<List<ConnectedAccountModel>>(
      '/profile/connected-accounts',
      fromJson: (json) => (json['accounts'] as List)
          .map((account) => ConnectedAccountModel.fromJson(account))
          .toList(),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to fetch connected accounts',
      );
    }
  }

  static Future<void> connectAccount(
    String provider,
    Map<String, dynamic> credentials,
  ) async {
    final response = await post(
      '/profile/connected-accounts',
      body: {'provider': provider, 'credentials': credentials},
    );

    if (!response.success) {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to connect account',
      );
    }
  }

  static Future<void> disconnectAccount(String accountId) async {
    final response = await delete('/profile/connected-accounts/$accountId');

    if (!response.success) {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to disconnect account',
      );
    }
  }

  // Security API Methods
  static Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await post(
      '/auth/change-password',
      body: {'current_password': currentPassword, 'new_password': newPassword},
    );

    if (!response.success) {
      if (response.statusCode == 400) {
        throw ErrorHandlerService.validationError(
          response.message ?? 'Invalid password',
        );
      } else if (response.statusCode == 401) {
        throw ErrorHandlerService.authError('Current password is incorrect');
      } else {
        throw ErrorHandlerService.networkError(
          response.message ?? 'Failed to change password',
        );
      }
    }
  }

  static Future<void> enableTwoFactor() async {
    final response = await post('/auth/two-factor/enable');

    if (!response.success) {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to enable two-factor authentication',
      );
    }
  }

  static Future<void> disableTwoFactor() async {
    final response = await post('/auth/two-factor/disable');

    if (!response.success) {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to disable two-factor authentication',
      );
    }
  }

  // Notification Settings API Methods
  static Future<void> updateNotificationSettings(
    Map<String, bool> settings,
  ) async {
    final response = await put(
      '/profile/notification-settings',
      body: {'settings': settings},
    );

    if (!response.success) {
      throw ErrorHandlerService.networkError(
        response.message ?? 'Failed to update notification settings',
      );
    }
  }

  // Analytics API Methods
  static Future<void> logEvent(
    String eventName,
    Map<String, dynamic> properties,
  ) async {
    try {
      await post(
        '/analytics/events',
        body: {
          'event': eventName,
          'properties': properties,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Analytics failures shouldn't break the app
      debugPrint('Analytics logging failed: $e');
    }
  }

  // Health check
  static Future<bool> checkHealth() async {
    try {
      final response = await get('/health');
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
