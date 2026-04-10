import '../models/order_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  /// Get all orders
  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {
          if (status != null) 'status': status,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = response.data['orders'] ?? [];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get order by ID
  Future<OrderModel> getOrder(String orderId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.orderDetails}/$orderId');

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception('Order not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Create order (checkout)
  Future<OrderModel> createOrder({
    required String paymentMethod,
    required String addressId,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.checkout, {},
        data: {
          'payment_method': paymentMethod,
          'address_id': addressId,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.statusCode == 201) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel order
  Future<OrderModel> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.orders}/$orderId/cancel', {},
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception('Failed to cancel order');
      }
    } catch (e) {
      rethrow;
    }
  }
}
