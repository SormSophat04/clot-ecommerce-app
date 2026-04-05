import 'package:get/get.dart';
import '../models/user_model.dart';
import '../sources/local/storage_service.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class AuthRepository extends GetxService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  /// Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Save token
        await _storageService.saveToken(data['token']);
        _apiClient.setToken(data['token']);
        // Save user data
        if (data['user'] != null) {
          await _storageService.saveUserData(data['user']);
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
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        // Save token
        await _storageService.saveToken(data['token']);
        _apiClient.setToken(data['token']);
        // Save user data
        if (data['user'] != null) {
          await _storageService.saveUserData(data['user']);
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
      await _apiClient.post(ApiConstants.logout);
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
        ApiConstants.forgotPassword,
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
