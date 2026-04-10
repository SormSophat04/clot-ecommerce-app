import 'package:get/get.dart';
import '../models/user_model.dart';
import '../sources/local/storage_service.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class AuthRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Invalid server response format');
  }

  Map<String, dynamic> _authPayload(dynamic rawData) {
    final root = _asMap(rawData);
    final nested = root['data'];
    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }
    return root;
  }

  String _extractToken(
    Map<String, dynamic> rootData,
    Map<String, dynamic> payloadData, {
    String? headerAuthorization,
  }) {
    final tokenKeys = <String>[
      'token',
      'accessToken',
      'access_token',
      'jwt',
      'idToken',
    ];

    for (final key in tokenKeys) {
      final raw = payloadData[key] ?? rootData[key];
      if (raw is String && raw.trim().isNotEmpty) {
        return raw.trim();
      }
    }

    if (headerAuthorization != null && headerAuthorization.trim().isNotEmpty) {
      final normalized = headerAuthorization.trim();
      if (normalized.toLowerCase().startsWith('bearer ')) {
        final bearerToken = normalized.substring(7).trim();
        if (bearerToken.isNotEmpty) {
          return bearerToken;
        }
      }
      return normalized;
    }

    throw Exception(
      'Server response is missing a valid auth token (checked token/accessToken/access_token/jwt/idToken and Authorization header)',
    );
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login, {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = _asMap(response.data);
        final payload = _authPayload(response.data);
        final authHeader = response.headers.value('authorization');
        final token = _extractToken(
          data,
          payload,
          headerAuthorization: authHeader,
        );
        // Save token
        await _storageService.saveToken(token);
        _apiClient.setToken(token);
        // Save user data
        final userRaw = payload['user'] ?? data['user'];
        if (userRaw is Map) {
          await _storageService.saveUserData(
            Map<String, dynamic>.from(userRaw),
          );
        }
        return data;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register, {
          'username': username,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _asMap(response.data);
        final payload = _authPayload(response.data);
        final authHeader = response.headers.value('authorization');
        final token = _extractToken(
          data,
          payload,
          headerAuthorization: authHeader,
        );
        // Save token
        await _storageService.saveToken(token);
        _apiClient.setToken(token);
        // Save user data
        final userRaw = payload['user'] ?? data['user'];
        if (userRaw is Map) {
          await _storageService.saveUserData(
            Map<String, dynamic>.from(userRaw),
          );
        }
        return data;
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout, {});
    } finally {
      // Clear local data regardless of API response
      _apiClient.clearToken();
      await _storageService.clearAuth();
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.forgotPassword, {},
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send reset email');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConstants.userProfile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.updateProfile,
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        },
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['user']);
        await _storageService.saveUserData(user.toJson());
        return user;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }
}
