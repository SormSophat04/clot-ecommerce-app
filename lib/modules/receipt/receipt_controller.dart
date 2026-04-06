import 'package:get/get.dart';

enum OrderStatus { processing, shipped, delivered, returned, cancelled }

class OrderModel {
  final String id;
  final int itemCount;
  final OrderStatus status;
  final DateTime date;
  final String address;
  final String phone;

  OrderModel({
    required this.id,
    required this.itemCount,
    required this.status,
    required this.date,
    required this.address,
    required this.phone,
  });
}

class ReceiptController extends GetxController {
  // Replace true with false to see the empty state
  final RxBool isEmpty = false.obs;
  
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<OrderStatus> selectedFilter = OrderStatus.processing.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    orders.assignAll([
      OrderModel(
        id: '#456765',
        itemCount: 4,
        status: OrderStatus.processing,
        date: DateTime(2023, 5, 28),
        address: '2715 Ash Dr. San Jose, South Dakota 83475',
        phone: '121-224-7890',
      ),
      OrderModel(
        id: '#454569',
        itemCount: 2,
        status: OrderStatus.processing,
        date: DateTime(2023, 5, 28),
        address: '2715 Ash Dr. San Jose, South Dakota 83475',
        phone: '121-224-7890',
      ),
      OrderModel(
        id: '#454809',
        itemCount: 1,
        status: OrderStatus.processing,
        date: DateTime(2023, 5, 28),
        address: '2715 Ash Dr. San Jose, South Dakota 83475',
        phone: '121-224-7890',
      ),
      OrderModel(
        id: '#456766',
        itemCount: 3,
        status: OrderStatus.shipped,
        date: DateTime(2023, 5, 27),
        address: '2715 Ash Dr. San Jose, South Dakota 83475',
        phone: '121-224-7890',
      ),
      OrderModel(
        id: '#456767',
        itemCount: 1,
        status: OrderStatus.delivered,
        date: DateTime(2023, 5, 25),
        address: '2715 Ash Dr. San Jose, South Dakota 83475',
        phone: '121-224-7890',
      ),
    ]);
  }

  void setFilter(OrderStatus status) {
    selectedFilter.value = status;
  }

  List<OrderModel> get filteredOrders {
    return orders.where((o) => o.status == selectedFilter.value).toList();
  }

  void exploreCategories() {
    // Navigate to categories or home
    if (Get.isRegistered<GetxController>()) {
      // Just a placeholder for actual navigation logic
      // e.g., Get.find<MainController>().changeTab(1);
    }
  }

  String statusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.returned: return 'Returned';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}