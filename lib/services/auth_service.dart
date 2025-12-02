import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  static Future<AuthResponse> signUp(String email, String password) async {
    final response = await SupabaseConfig.client.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    final response = await SupabaseConfig.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  static Future<void> signOut() async {
    await SupabaseConfig.client.auth.signOut();
  }

  static User? get currentUser => SupabaseConfig.client.auth.currentUser;
}
