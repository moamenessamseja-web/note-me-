import 'package:flutter/material.dart';
import 'package:note_me/design/strings.dart';
import 'package:note_me/design/tokens.dart';
import 'package:note_me/services/settings_service.dart';
import 'package:note_me/widgets/markdown_view.dart';

class ReaderScreen extends StatelessWidget {
  final String? title;
  final String? content;
  const ReaderScreen({super.key, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    final src = content ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title ?? L.nav_reader)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.x4),
          child: MarkdownView(data: src, fontSize: SettingsService.fontSize),
        ),
      ),
    );
  }
}
