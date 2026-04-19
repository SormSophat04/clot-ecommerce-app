import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:clot_ecommerce_app/core/config/app_config.dart';
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/data/sources/local/storage_service.dart';
import 'api_constants.dart';
import '../utils/app_logger.dart';

class ApiClient extends GetxService {
  late Dio _dio;
  String _token = '';
  bool _isHandlingSessionExpiry = false;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.envConfig.apiBaseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to headers if available
          if (_token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          AppLogger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = '';
  }

  // GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      await _handleError(e);
      rethrow;
    }
  }

  // POST request
  Future<Response<dynamic>> post(
    String path,
    Map<String, String> map, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data ?? map,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      await _handleError(e);
      rethrow;
    }
  }

  // PUT request
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      await _handleError(e);
      rethrow;
    }
  }

  // DELETE request
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      await _handleError(e);
      rethrow;
    }
  }

  // PATCH request
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      await _handleError(e);
      rethrow;
    }
  }

  // Handle Dio errors
  Future<void> _handleError(DioException error) async {
    if (_shouldHandleSessionExpiry(error)) {
      await _handleSessionExpiry();
      return;
    }
  }

  /// Extracts a human-readable error message from a DioException.
  /// Prefers the server's `message` field in the ApiResponse body,
  /// then falls back to a descriptive generic message.
  String _extractErrorMessage(DioException error) {
    // Try to get the server's actual message from the response body
    final responseData = error.response?.data;
    if (responseData is Map) {
      final serverMessage = responseData['message'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return serverMessage.trim();
      }
    }

    // Fallback to descriptive messages based on error type / status code
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return 'Invalid request. Please check your input.';
          case 401:
            return 'Your session has expired. Please log in again.';
          case 403:
            return 'You are not allowed to perform this action.';
          case 404:
            return 'The requested resource was not found.';
          case 409:
            return 'A conflict occurred. The data may already exist.';
          case 422:
            return 'Validation failed. Please review your input.';
          case 500:
            return 'Something went wrong on the server. Please try again later.';
          case 503:
            return 'Service is temporarily unavailable. Please try again later.';
          default:
            return 'Unexpected server error (${error.response?.statusCode}).';
        }
      default:
        return 'Network error. Please check your internet connection.';
    }
  }

  bool _shouldHandleSessionExpiry(DioException error) {
    final statusCode = error.response?.statusCode;
    final requestPath = error.requestOptions.path;
    if (_isPublicAuthEndpoint(requestPath)) return false;

    if (statusCode == 401) {
      return true;
    }

    if (statusCode == 403) {
      final normalizedBody = _normalizeBodyForCheck(error.response?.data);
      return normalizedBody.contains('expired') ||
          normalizedBody.contains('token') ||
          normalizedBody.contains('invalid credentials') ||
          normalizedBody.contains('unauthorized');
    }

    return false;
  }

  bool _isPublicAuthEndpoint(String path) {
    final normalized = path.trim().toLowerCase();
    return normalized.contains(ApiConstants.login.toLowerCase()) ||
        normalized.contains(ApiConstants.register.toLowerCase()) ||
        normalized.contains(ApiConstants.forgotPassword.toLowerCase()) ||
        normalized.contains(ApiConstants.resetPassword.toLowerCase()) ||
        normalized.contains(ApiConstants.refreshToken.toLowerCase());
  }

  Future<void> _handleSessionExpiry() async {
    if (_isHandlingSessionExpiry) return;
    _isHandlingSessionExpiry = true;

    try {
      clearToken();

      if (Get.isRegistered<StorageService>()) {
        await Get.find<StorageService>().clearAuth();
      }

      final currentRoute = Get.currentRoute;
      if (currentRoute != Routes.login && currentRoute != Routes.register) {
        await Future<void>.delayed(Duration.zero);
        Get.offAllNamed(Routes.login);
      }
    } finally {
      _isHandlingSessionExpiry = false;
    }
  }

  String _normalizeBodyForCheck(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.toLowerCase();
    if (value is Map) {
      return value.values.map((item) => '$item').join(' ').toLowerCase();
    }
    return value.toString().toLowerCase();
  }
}
