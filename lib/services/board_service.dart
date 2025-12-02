import '../config/supabase_config.dart';
import '../models/board_model.dart';

class BoardService {
  static final _client = SupabaseConfig.client;

  // Obtener boards del usuario
  static Future<List<BoardModel>> getBoards(String userId) async {
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
  // Crear board: devuelve el objeto creado (o null si falla)
  static Future<BoardModel?> createBoard(String title, String userId) async {
    try {
      final response = await _client
          .from('boards')
          .insert({
            'title': title,
            'user_id': userId,
          })
          .select()
          .single();

  // ignore: avoid_print
  print('BoardService.createBoard response: $response');

  final row = Map<String, dynamic>.from(response);
  return BoardModel.fromJson(row);
    } catch (e) {
      // ignore: avoid_print
      print('BoardService.createBoard error: $e');
      return null;
    }
  }

  // Editar board

  static Future<void> updateBoard(dynamic id, String title) async {
    await _client.from('boards').update({
      'title': title,
    }).eq('id', id);
  }

  // Debug: obtener todos los boards (sin filtro por usuario)
  static Future<List<BoardModel>> getAllBoards() async {
    final data = await _client.from('boards').select().order('id');
    return (data as List).map((e) => BoardModel.fromJson(e)).toList();
  }

  // Eliminar board

  static Future<void> deleteBoard(dynamic id) async {
    await _client.from('boards').delete().eq('id', id);
  }
}