import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/list_model.dart';

class ListService {
  static final _client = SupabaseConfig.client;

  // Obtener listas por tablero
  static Future<List<ListModel>> getLists(int boardId) async {
    final response = await _client
        .from('lists')
        .select()
        .eq('board_id', boardId)
        .order('position', ascending: true);

    final List data = response as List<dynamic>;
    return data.map<ListModel>((d) => ListModel.fromJson(d as Map<String, dynamic>)).toList();
  }

  // Crear nueva lista
  static Future<void> createList(String title, int boardId) async {
    // Obtener listas actuales para asignar position
    final resp = await _client
        .from('lists')
        .select('id')
        .eq('board_id', boardId);

    final List existing = resp as List<dynamic>;
    final int pos = existing.length;

    await _client.from('lists').insert({
      'title': title,
      'board_id': boardId,
      'position': pos,
    });
  }

  // ==========================================================
  // RENOMBRAR LISTA
  // ==========================================================
  static Future<void> renameList(int listId, String newName) async {
    await _client.from('lists').update({'title': newName}).eq('id', listId);
  }

  // ==========================================================
  // ELIMINAR LISTA
  // ==========================================================
  static Future<void> deleteList(int listId) async {
    await _client.from('lists').delete().eq('id', listId);
  }

  // ==========================================================
  // ACTUALIZAR POSICIÓN (para reordenar listas)
  // ==========================================================
  static Future<void> updatePosition(int listId, int newPosition) async {
    await _client.from('lists').update({'position': newPosition}).eq('id', listId);
  }
}
