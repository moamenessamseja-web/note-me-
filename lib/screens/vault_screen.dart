import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/vault_service.dart';
import '../models/note.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    await VaultService.init();
    if (VaultService.instance.hasPassword()) {
      // If vault is locked, show prompt for password
      setState(() => _notes = []);
    } else {
      setState(() => _notes = VaultService.vaultNotes());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.nav_vault)),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : !VaultService.instance.isLocked
                ? _buildUnlockedView()
                : _buildLockedView(),
      ),
    );
  }

  Widget _buildLockedView() {
    final passwordController = TextEditingController();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpace.x4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(L.vault_set_password, style: AppText.h2),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: L.vault_password,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text.isNotEmpty) {
                  await VaultService.setPassword(passwordController.text);
                  _loadNotes();
                }
              },
              child: const Text('إعداد كلمة المرور'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedView() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpace.x2),
      itemCount: _notes.length,
      itemBuilder: (context, i) {
        final note = _notes[i];
        return Card(
          margin: EdgeInsets.only(bottom: AppSpace.x2),
          child: ListTile(
            title: Text(note.title, style: AppText.body),
            subtitle: Text(note.preview, style: AppText.bodySm),
            leading: Icon(Icons.lock, color: AppColors.accent),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(note.title)),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: AppColors.danger),
              onPressed: () async {
                await VaultService.deleteVaultNote(note.id);
                _loadNotes();
              },
            ),
          ),
        );
      },
    );
  }
}
