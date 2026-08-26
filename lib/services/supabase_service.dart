import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/crisis_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Authentification
  Future<AuthResponse> signUp(String email, String password, String role) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'role': role},
    );
    return res;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Crises
  Future<void> logCrisis(Crisis crisis) async {
    await _client.from('crises').insert(crisis.toJson());
  }

  Future<List<Crisis>> getCrises() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    
    final response = await _client
        .from('crises')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Crisis.fromJson(json)).toList();
  }

  // Hydratation
  Future<void> addWater(double liters) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('water_logs').insert({
      'user_id': userId,
      'liters': liters,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }
}
