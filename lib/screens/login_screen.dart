import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;
  String _selectedRole = 'patient';

  Future<void> _handleAuth(bool isSignUp) async {
    setState(() => _isLoading = true);
    try {
      if (isSignUp) {
        await _supabaseService.signUp(_emailController.text, _passwordController.text, _selectedRole);
      } else {
        await _supabaseService.signIn(_emailController.text, _passwordController.text);
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.water_drop_rounded, size: 70, color: Color(0xFF38BDF8)),
              const SizedBox(height: 12),
              const Text(
                "Drep'Care",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A365D)),
              ),
              const Text(
                "Votre compagnon santé & sérénité",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: "Type de profil",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'patient', child: Text('Patient')),
                  DropdownMenuItem(value: 'parent', child: Text('Proche / Parent')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _handleAuth(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A365D),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Se connecter', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _handleAuth(true),
                          child: const Text("Créer un compte", style: TextStyle(color: Color(0xFF38BDF8))),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
