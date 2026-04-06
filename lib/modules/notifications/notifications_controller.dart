import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String message;
  final bool isUnread;

  NotificationItem({
    required this.id,
    required this.message,
    this.isUnread = false,
  });
}

class NotificationsController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate loading data. For now, we populate it to match the provided screenshot.
    // To see the empty state, just clear this list.
    notifications.addAll([
      NotificationItem(
        id: '1',
        message: 'Gilbert, you placed and order check your order history for full details',
        isUnread: true,
      ),
      NotificationItem(
        id: '2',
        message: 'Gilbert, Thank you for shopping with us we have canceled order #24568.',
        isUnread: false,
      ),
      NotificationItem(
        id: '3',
        message: 'Gilbert, your Order #24568 has been confirmed check your order history for full details',
        isUnread: false,
      ),
    ]);
  }

  void clearNotifications() {
    notifications.clear();
  }
}