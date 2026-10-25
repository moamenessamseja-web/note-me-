import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.nav_about)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpace.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L.about_title, style: AppText.h1),
              const SizedBox(height: 16),
              Text(L.about_version, style: AppText.body),
              const SizedBox(height: 8),
              Text(L.about_desc, style: AppText.bodySm),
              const SizedBox(height: 16),
              Text(L.about_license, style: AppText.bodySm),
            ],
          ),
        ),
      ),
    );
  }
}
