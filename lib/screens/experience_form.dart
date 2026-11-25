import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  String _startedAt = '';
  String _endedAt = '';
  bool _isSubmitting = false;

  final _categories = const {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  String? _validateDate(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) {
      return 'Gunakan format YYYY-MM-DD.';
    }

    final date = DateTime.tryParse(text);
    if (date == null || date.toIso8601String().substring(0, 10) != text) {
      return 'Tanggal tidak valid.';
    }

    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_startedAt.isNotEmpty &&
        _endedAt.isNotEmpty &&
        DateTime.parse(_endedAt).isBefore(DateTime.parse(_startedAt))) {
      _showMessage('Tanggal selesai tidak boleh sebelum tanggal mulai.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final loggedIn = await ensureLoggedIn(context);
      if (!mounted || !loggedIn) return;

      final auth = context.read<AuthState>();
      final token = auth.token;
      if (token == null) return;

      final experience = Experience(
        title: _title,
        description: _description,
        category: _category,
        thumbnail: _thumbnail.isEmpty ? null : _thumbnail,
        startedAt: _startedAt.isEmpty ? null : _startedAt,
        endedAt: _endedAt.isEmpty ? null : _endedAt,
      );

      final saved = await context.read<ApiClient>().createExperience(
        experience,
        token: token,
      );

      if (!mounted) return;
      FocusScope.of(context).unfocus();

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: Text('${saved.title} sudah tersimpan di Django.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;

      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState tetap menghapus token lokal melalui finally.
        }

        if (!mounted) return;
        _showMessage('Sesi berakhir. Silakan login kembali.');

        final loggedIn = await ensureLoggedIn(context);
        if (!mounted) return;

        if (loggedIn) {
          _showMessage('Login berhasil. Tekan Simpan untuk mencoba lagi.');
        }
      } else {
        _showMessage(error.message);
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        'Belum dapat memastikan hasil penyimpanan. '
        'Periksa koneksi dan daftar Experience sebelum mencoba lagi.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Experience')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 255,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul tidak boleh kosong.';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong.';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: 'full-time',
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'URL gambar (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;

                    final uri = Uri.tryParse(text);
                    if (uri == null ||
                        !uri.hasAuthority ||
                        uri.host.isEmpty ||
                        !['http', 'https'].contains(uri.scheme)) {
                      return 'Masukkan URL http atau https yang valid.';
                    }
                    return null;
                  },
                  onSaved: (value) => _thumbnail = value?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal mulai (opsional)',
                    hintText: '2026-11-25',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: _validateDate,
                  onSaved: (value) => _startedAt = value?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal selesai (opsional)',
                    hintText: 'Kosongkan jika masih berlangsung',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: _validateDate,
                  onSaved: (value) => _endedAt = value?.trim() ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
