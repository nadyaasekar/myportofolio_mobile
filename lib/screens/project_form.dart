import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _projectName = '';
  String _description = '';
  String _category = 'Web Development';
  String _technologies = '';
  String _projectLink = '';

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Proyek: $_projectName'),
                Text('Deskripsi: $_description'),
                Text('Kategori: $_category'),
                Text('Teknologi: $_technologies'),
                Text('Tautan: $_projectLink'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _formKey.currentState!.reset();

                setState(() {
                  _projectName = '';
                  _description = '';
                  _category = 'Web Development';
                  _technologies = '';
                  _projectLink = '';
                });
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
        title: const Text('Add Project Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: _decoration('Nama Proyek'),
                onSaved: (value) {
                  _projectName = value?.trim() ?? '';
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama proyek tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _decoration('Deskripsi Proyek'),
                maxLines: 5,
                onSaved: (value) {
                  _description = value?.trim() ?? '';
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi proyek tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _decoration('Kategori Proyek'),
                initialValue: 'Web Development',
                isExpanded: true,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value ?? 'Web Development';
                  });
                },
                onSaved: (value) {
                  _category = value ?? 'Web Development';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _decoration(
                  'Teknologi yang Digunakan',
                  hint: 'Contoh: Flutter, Django, Figma',
                ),
                onSaved: (value) {
                  _technologies = value?.trim() ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _decoration(
                  'Tautan Proyek',
                  hint: 'URL proyek (opsional)',
                ),
                keyboardType: TextInputType.url,
                onSaved: (value) {
                  _projectLink = value?.trim() ?? '';
                },
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
