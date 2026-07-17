import 'notification_service_mobile.dart'
    if (dart.library.html) 'notification_service_web.dart';

class NotificationService {
  static Future<void> init() => initImpl();

  static Future<void> showNotification(int id, String title, String body) =>
      showNotificationImpl(id, title, body);
}
