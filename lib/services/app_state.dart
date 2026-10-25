/// Application-wide reactive state.
///
/// Uses a [ValueNotifier] so any screen can call [notify] and all
/// [ListenableBuilder] widgets rebuild without a full restart.
class AppState extends ValueNotifier<int> {
  AppState._() : super(0);
  static final AppState instance = AppState._();

  /// Bump the version to force rebuilds.
  void notify() => value++;
}