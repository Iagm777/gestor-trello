import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/board_model.dart';

class BoardService {
  static final _client = SupabaseConfig.client;

  // Obtener los tableros del usuario
  static Future<List<BoardModel>> getBoards([String? userId]) async {
    final uid = userId ?? _client.auth.currentUser?.id;

  if (uid == null) return [];

  final response = await _client
    .from('boards')
    .select()
    .eq('user_id', uid)
    .order('created_at');

  final List data = response as List<dynamic>;

  return data.map<BoardModel>((d) => BoardModel.fromJson(d as Map<String, dynamic>)).toList();
  }

  // Crear un nuevo tablero
  static Future<void> createBoard(String title, [String? userId]) async {
    final uid = userId ?? _client.auth.currentUser?.id;

    await _client.from('boards').insert({
      'title': title,
      'user_id': uid,
    });
  }

  // Eliminar un tablero
  static Future<void> deleteBoard(int id) async {
    await _client.from('boards').delete().eq('id', id);
  }
}
