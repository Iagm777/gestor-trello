import '../config/supabase_config.dart';
import '../models/board_model.dart';

class BoardService {
  static final _client = SupabaseConfig.client;

  // Obtener boards del usuario
  static Future<List<BoardModel>> getBoards(int userId) async {
    final data = await _client
        .from('boards')
        .select()
        .eq('user_id', userId)
        .order('id');

    return (data as List)
        .map((e) => BoardModel.fromJson(e))
        .toList();
  }

  // Crear board
  static Future<void> createBoard(String title, int userId) async {
    await _client.from('boards').insert({
      'title': title,
      'user_id': userId,
    });
  }

  // Editar board
  static Future<void> updateBoard(int id, String title) async {
    await _client.from('boards').update({
      'title': title,
    }).eq('id', id);
  }

  // Eliminar board
  static Future<void> deleteBoard(int id) async {
    await _client.from('boards').delete().eq('id', id);
  }
}