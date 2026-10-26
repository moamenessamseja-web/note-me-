import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import 'services/app_error_service.dart';
import 'services/app_state.dart';
import 'services/settings_service.dart';
import 'services/storage_service.dart';
import 'services/vault_service.dart';
import 'screens/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await StorageService.init();
    await SettingsService.init();
    await AppErrorService.init();
    await VaultService.init();
  } catch (e) {
    runApp(_StartupErrorApp(details: e.toString()));
    return;
  }

  runApp(const NoteMeApp());
}

class _StartupErrorApp extends StatelessWidget {
  final String details;
  const _StartupErrorApp({required this.details});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعذّر بدء التطبيق',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'حدث خطأ أثناء إعداد التخزين المحلي. البيانات لم تُمسح.',
                      ),
                      const SizedBox(height: 16),
                      SelectableText(details, textDirection: TextDirection.ltr),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class NoteMeApp extends StatelessWidget {
  const NoteMeApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: L.app_title,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: SettingsService.themeMode,
          locale: Locale(L.lang),
          home: Directionality(textDirection: L.direction, child: const MainShell()),
        ),
      );
}
