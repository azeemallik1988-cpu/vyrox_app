import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/config/vyrox_config.dart';

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
      setState(() => error = 'Type a valid email address.');
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
        if (mounted) Navigator.pop(context, true); // Safe pop!
      } else {
        setState(() {
          error = 'Account created, but Confirm email is still ON in Supabase. Turn it OFF, then Sign in.';
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
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          const Text(
            'VYROX AI',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in or create a free account to sync credits and creations.',
            style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 15),
          ),
          if (!VyroxConfig.isConfigured) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Supabase keys missing in vyrox_config.dart',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 32),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: const Color(0xFF181228),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: password,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password (6+ characters)',
              labelStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: const Color(0xFF181228),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 14),
            Text(error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B4FCE),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: busy || !VyroxConfig.isConfigured
                  ? null
                  : () => _run(() async {
                        await AuthController.signIn(email.text.trim(), password.text);
                      }),
              child: Text(
                busy ? 'Please wait…' : 'Sign In',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: busy || !VyroxConfig.isConfigured
                  ? null
                  : () => _run(() async {
                        await AuthController.signUp(email.text.trim(), password.text);
                        if (!AuthController.signedIn) {
                          await AuthController.signIn(email.text.trim(), password.text);
                        }
                      }),
              child: const Text(
                'Create Free Account',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
