import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://pfihmktkvivtxowfovyl.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmaWhta3Rrdml2dHhvd2ZvdnlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1NTc3NjMsImV4cCI6MjA4MDEzMzc2M30.D5PEgBBzGexLnp-vJBZG9rJgNlPeN2eR62jTLxgXtQg';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
