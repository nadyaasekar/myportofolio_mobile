import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startYearController = TextEditingController();

  String _institution = '';
  String _degree = '';
  int _startYear = 0;
  String _endYear = 'Sekarang';

  @override
  void dispose() {
    _startYearController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  String? _validateRequiredText(String? value, String label, int maxLength) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$label tidak boleh kosong!';
    }

    if (text.length > maxLength) {
      return '$label maksimal $maxLength karakter!';
    }

    return null;
  }

  String? _validateStartYear(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Tahun mulai tidak boleh kosong!';
    }

    final year = int.tryParse(text);

    if (year == null || !RegExp(r'^\d{4}$').hasMatch(text)) {
      return 'Masukkan tahun berupa 4 digit angka!';
    }

    if (year < 1900 || year > DateTime.now().year) {
      return 'Tahun mulai harus antara 1900 dan tahun ini!';
    }

    return null;
  }

  String? _validateEndYear(String? value) {
    final error = _validateRequiredText(value, 'Tahun selesai', 50);
    if (error != null) {
      return error;
    }

    final text = value!.trim();

    if (text.toLowerCase() == 'sekarang') {
      return null;
    }

    final endYear = int.tryParse(text);

    if (endYear == null || !RegExp(r'^\d{4}$').hasMatch(text)) {
      return 'Isi tahun 4 digit atau Sekarang!';
    }

    if (endYear < 1900 || endYear > DateTime.now().year) {
      return 'Untuk pendidikan yang belum selesai, isi Sekarang!';
    }

    final startYear = int.tryParse(_startYearController.text.trim());

    if (startYear != null && endYear < startYear) {
      return 'Tahun selesai tidak boleh sebelum tahun mulai!';
    }

    return null;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ringkasan Education'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: $_institution'),
                const SizedBox(height: 8),
                Text('Gelar/Jenjang: $_degree'),
                const SizedBox(height: 8),
                Text('Tahun mulai: $_startYear'),
                const SizedBox(height: 8),
                Text('Tahun selesai: $_endYear'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Education'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: _decoration(
                    'Institusi',
                    hint: 'Contoh: Universitas Indonesia',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    return _validateRequiredText(value, 'Institusi', 255);
                  },
                  onSaved: (value) {
                    _institution = value!.trim();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: _decoration(
                    'Gelar/Jenjang',
                    hint: 'Contoh: S1 Sistem Informasi',
                  ),
                  validator: (value) {
                    return _validateRequiredText(value, 'Gelar/Jenjang', 255);
                  },
                  onSaved: (value) {
                    _degree = value!.trim();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startYearController,
                  decoration: _decoration('Tahun mulai', hint: 'Contoh: 2025'),
                  keyboardType: TextInputType.number,
                  validator: _validateStartYear,
                  onSaved: (value) {
                    _startYear = int.parse(value!.trim());
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: 'Sekarang',
                  decoration: _decoration(
                    'Tahun selesai',
                    hint: 'Contoh: 2024 atau Sekarang',
                  ),
                  validator: _validateEndYear,
                  onSaved: (value) {
                    final text = value!.trim();
                    _endYear = text.toLowerCase() == 'sekarang'
                        ? 'Sekarang'
                        : text;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
