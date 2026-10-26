import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:note_me/design/strings.dart';
import 'package:note_me/design/tokens.dart';

class ReaderScreen extends StatelessWidget {
  final String? title;
  final String? content;
  const ReaderScreen({super.key, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    final src = content ?? '';
    final htmlString = md.markdownToHtml(src);
    return Scaffold(
      appBar: AppBar(title: Text(title ?? L.nav_reader)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.x4),
          child: Text(
            htmlString,
            style: AppText.body,
          ),
        ),
      ),
    );
  }
}
