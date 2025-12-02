import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> register() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    // Basic client-side validation to avoid weak password errors from Supabase
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Introduce un email')));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')));
      return;
    }

    setState(() => loading = true);

    try {
      final response = await AuthService.signUp(
        email,
        password,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada. ¡Inicia sesión!')),
        );

        Navigator.pop(context);
      } else if (response.session == null && response.user == null) {
        // Supabase may return no user but no exception; show friendly message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro enviado. Revisa tu email para confirmar.')));
      }
    } catch (e) {
      // Show a cleaner error message for common auth exceptions
      final msg = e.toString();
      if (msg.contains('AuthWeakPasswordException') || msg.toLowerCase().contains('password')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña es demasiado débil. Usa al menos 6 caracteres.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: Text(loading ? 'Cargando...' : 'Registrarse'),
            )
          ],
        ),
      ),
    );
  }
}
