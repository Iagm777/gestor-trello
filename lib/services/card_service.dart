import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/card_model.dart';

class CardService {
  static final _client = SupabaseConfig.client;

  // ==========================================================
  // OBTENER TARJETAS DE UNA LISTA
  // ==========================================================
  static Future<List<CardModel>> getCards(int listId) async {
    final response = await _client
        .from('cards')
        .select()
        .eq('list_id', listId)
        .order('position', ascending: true);

    final List data = response as List<dynamic>;

    return data
        .map<CardModel>((d) => CardModel.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  // ==========================================================
  // CREAR NUEVA TARJETA
  // ==========================================================
  static Future<void> createCard(String title, int listId) async {
    // Obtener cuántas tarjetas existen para calcular la posición
    final resp = await _client
        .from('cards')
        .select('id')
        .eq('list_id', listId);

    final List existing = resp as List<dynamic>;
    final int pos = existing.length;

    await _client.from('cards').insert({
      'title': title,
      'list_id': listId,
      'position': pos,
    });
  }

  // ==========================================================
  // ACTUALIZAR TARJETA (TÍTULO + DESCRIPCIÓN)
  // ==========================================================
  static Future<void> updateCard(int id, String title, String? description) async {
    await _client.from('cards').update({
      'title': title,
      'description': description,
    }).eq('id', id);
  }

  // ==========================================================
  // ACTUALIZAR POSICIÓN (para Drag & Drop)
  // ==========================================================
  static Future<void> updatePosition(int cardId, int newPosition) async {
    await _client
        .from('cards')
        .update({'position': newPosition})
        .eq('id', cardId);
  }

  // ==========================================================
  // MOVER TARJETA ENTRE LISTAS
  // ==========================================================
  static Future<void> moveCard(int cardId, int newListId) async {
    // Obtener cuántas tarjetas hay en la nueva lista
    final resp = await _client
        .from('cards')
        .select('id')
        .eq('list_id', newListId);

    final List existing = resp as List<dynamic>;
    final int newPos = existing.length;

    await _client.from('cards').update({
      'list_id': newListId,
      'position': newPos,
    }).eq('id', cardId);
  }

  // ==========================================================
  // ELIMINAR TARJETA
  // ==========================================================
  static Future<void> deleteCard(int cardId) async {
    await _client.from('cards').delete().eq('id', cardId);
  }

  // ==========================================================
  // ETIQUETAS
  // ==========================================================
  static Future<void> updateLabels(int cardId, List<String> labels) async {
    await _client
        .from('cards')
        .update({'labels': labels})
        .eq('id', cardId);
  }

  // ==========================================================
  // CHECKLIST
  // ==========================================================
  static Future<void> toggleChecklist(int cardId, bool value) async {
    await _client
        .from('cards')
        .update({'has_checklist': value})
        .eq('id', cardId);
  }

  // ==========================================================
  // FECHA LÍMITE
  // ==========================================================
  static Future<void> updateDueDate(int cardId, DateTime date) async {
    await _client
        .from('cards')
        .update({'due_date': date.toIso8601String()})
        .eq('id', cardId);
  }

  // ==========================================================
  // USUARIOS ASIGNADOS
  // ==========================================================
  static Future<void> updateAssigned(int cardId, List<String> emails) async {
    await _client
        .from('cards')
        .update({'assigned_users': emails})
        .eq('id', cardId);
  }
}
