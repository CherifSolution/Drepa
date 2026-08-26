import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Supabase
  await Supabase.initialize(
    url: 'https://rpdnpqlbrritmariyefd.supabase.co',
    anonKey: 'sb_publishable_PiDKq4XG-LE1savclwk07A_BfQlca9F',
  );

  runApp(const DrepCareApp());
}

class DrepCareApp extends StatelessWidget {
  const DrepCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drep'Care",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A365D), // Bleu Marine
          primary: const Color(0xFF1A365D),
          secondary: const Color(0xFF38BDF8), // Bleu Ciel
          surface: const Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: Supabase.instance.client.auth.currentSession == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
