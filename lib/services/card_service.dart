import '../config/supabase_config.dart';
import '../models/card_model.dart';

class CardService {
  static final _client = SupabaseConfig.client;

  // Obtener tarjetas por lista
  static Future<List<CardModel>> getCards(dynamic listId) async {
    final response = await _client
        .from('cards')
        .select()
        .eq('list_id', listId)
        .order('position', ascending: true);

    final List data = response as List;

    return data.map((item) => CardModel.fromJson(item)).toList();
  }

  // Crear tarjeta
  static Future<void> createCard(String title, dynamic listId) async {
    final resp = await _client
        .from('cards')
        .select('id')
        .eq('list_id', listId);

    final List existing = resp as List;
    final pos = existing.length;

    await _client.from('cards').insert({
      'title': title,
      'list_id': listId,
      'position': pos,
    });
  }

  // Editar tarjeta
  static Future<void> updateCard(dynamic id, String title, String? description) async {
    await _client.from('cards').update({
      'title': title,
      'description': description,
    }).eq('id', id);
  }

  // Actualizar posición (para Drag & Drop)
  static Future<void> updatePosition(dynamic cardId, int newPosition) async {
    await _client
        .from('cards')
        .update({'position': newPosition})
        .eq('id', cardId);
  }

  // Mover tarjeta entre listas
  static Future<void> moveCard(dynamic cardId, dynamic newListId) async {
    final resp = await _client
        .from('cards')
        .select('id')
        .eq('list_id', newListId);

    final List existing = resp as List;
    final int newPos = existing.length;

    await _client.from('cards').update({
      'list_id': newListId,
      'position': newPos,
    }).eq('id', cardId);
  }

  // Actualizar etiquetas
  static Future<void> updateLabels(dynamic cardId, List<String> labels) async {
    await _client
        .from('cards')
        .update({'labels': labels})
        .eq('id', cardId);
  }

  // Toggle checklist
  static Future<void> toggleChecklist(dynamic cardId, bool value) async {
    await _client
        .from('cards')
        .update({'has_checklist': value})
        .eq('id', cardId);
  }

  // Actualizar fecha límite
  static Future<void> updateDueDate(dynamic cardId, DateTime? date) async {
    await _client
        .from('cards')
        .update({'due_date': date?.toIso8601String()})
        .eq('id', cardId);
  }

  // Actualizar usuarios asignados
  static Future<void> updateAssigned(dynamic cardId, List<String> emails) async {
    await _client
        .from('cards')
        .update({'assigned_users': emails})
        .eq('id', cardId);
  }

  // Eliminar tarjeta
  static Future<void> deleteCard(dynamic id) async {
    await _client.from('cards').delete().eq('id', id);
  }
}
