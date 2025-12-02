import '../config/supabase_config.dart';
import '../models/list_model.dart';

class ListService {
  static final _client = SupabaseConfig.client;

  // Obtener listas de un tablero
  static Future<List<ListModel>> getLists(int boardId) async {
    final response = await _client
        .from('lists')
        .select()
        .eq('board_id', boardId)
        .order('position', ascending: true);

    final List data = response as List;

    return data.map((item) => ListModel.fromJson(item)).toList();
  }

  // Crear lista
  static Future<void> createList(String title, int boardId) async {
    final resp = await _client
        .from('lists')
        .select('id')
        .eq('board_id', boardId);

    final List existing = resp as List<dynamic>;
    final pos = existing.length;

    await _client.from('lists').insert({
      'title': title,
      'board_id': boardId,
      'position': pos,
    });
  }

  // Editar lista
  static Future<void> updateList(int id, String title) async {
    await _client.from('lists').update({
      'title': title,
    }).eq('id', id);
  }

  // Renombrar lista (alias para compatibilidad)
  static Future<void> renameList(int id, String newName) async {
    await updateList(id, newName);
  }

  // Actualizar posición de lista
  static Future<void> updatePosition(int id, int newPosition) async {
    await _client.from('lists').update({
      'position': newPosition,
    }).eq('id', id);
  }

  // Eliminar lista
  static Future<void> deleteList(int id) async {
    await _client.from('lists').delete().eq('id', id);
  }
}
