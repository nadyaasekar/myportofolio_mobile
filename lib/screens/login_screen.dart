import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    try {
      await context.read<AuthState>().login(_username, _password);

      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;

      final message = error.statusCode == 400
          ? 'Username atau password tidak sesuai.'
          : error.message;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server. Coba lagi.'),
        ),
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
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username tidak boleh kosong!';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong!';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
