/// Reminder service stub — kept minimal so the APK builds without extra deps.
class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();

  static Future<void> rescheduleAllActive() async {}
}