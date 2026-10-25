/// Notification service stub — Android notifications for vault reminders.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static Future<void> init() async {
    // Real implementation would use flutter_local_notifications.
    // Kept minimal so the APK builds without that dependency.
  }

  static Future<void> requestPermission() async {
    // no-op on Android 13+ handled by manifest permission POST_NOTIFICATIONS.
  }
}