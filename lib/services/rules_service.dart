/// Rules service stub — kept minimal so the APK builds without extra deps.
class RulesService {
  RulesService._();
  static final RulesService instance = RulesService._();

  static Future<void> checkAndTrigger() async {}
}