import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_controller.dart';
import '../../core/config/vyrox_config.dart';
import '../../core/theme/vyrox_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  String _clean(Object e) {
    final raw = e.toString();
    if (raw.contains('anonymous') || raw.contains('Anonymous')) {
      return 'Type your email and password first, then tap Create free account.';
    }
    if (raw.contains('Invalid login credentials')) {
      return 'Wrong email/password, or no account yet. Use Create free account.';
    }
    if (raw.contains('already registered') || raw.contains('User already')) {
      return 'This email already exists. Use Sign in.';
    }
    if (raw.toLowerCase().contains('password')) {
      return 'Password must be at least 6 characters.';
    }
    return raw;
  }

  Future<void> _run(Future<void> Function() action) async {
    final mail = email.text.trim();
    final pass = password.text;

    if (mail.isEmpty || !mail.contains('@')) {
      setState(() => error = 'Type a real email address.');
      return;
    }
    if (pass.length < 6) {
      setState(() => error = 'Password must be at least 6 characters.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
      if (AuthController.signedIn) {
        if (mounted) context.pop(true);
      } else {
        setState(() {
          error =
              'Account created, but Confirm email is still ON in Supabase. Turn it OFF, then Sign in.';
        });
      }
    } catch (e) {
      setState(() => error = _clean(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroxColors.bg,
      appBar: AppBar(title: const Text('Sign in')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const Text(
            'VYROX account',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Type email + password, then Create free account.',
            style: TextStyle(color: Color(0xFFB9B9C6)),
          ),
          if (!VyroxConfig.isConfigured) ...[
            const SizedBox(height: 16),
            const Text(
              'Add Project URL and anon key in vyrox_config.dart first.',
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ],
          const SizedBox(height: 24),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: VyroxColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: 'Password (6+ characters)',
              filled: true,
              fillColor: VyroxColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.redAccent)),
          ],
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: busy || !VyroxConfig.isConfigured
                ? null
                : () => _run(() async {
                      await AuthController.signUp(
                        email.text.trim(),
                        password.text,
                      );
                      if (!AuthController.signedIn) {
                        await AuthController.signIn(
                          email.text.trim(),
                          password.text,
                        );
                      }
                    }),
            child: const Text('Create free account'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: busy || !VyroxConfig.isConfigured
                      ? null
                      : () => _run(() async {
                            await AuthController.signIn(
                              email.text.trim(),
                              password.text,
                            );
                          }),
                  borderRadius: BorderRadius.circular(18),
                  child: Center(
                    child: Text(
                      busy ? 'Please wait…' : 'Sign in',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
