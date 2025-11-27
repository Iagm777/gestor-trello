import '../models/card_model.dart';

/// Servicio de Tarjetas
abstract class CardService {
  /// Obtiene todas las tarjetas de una lista
  Future<List<CardModel>> getListCards(String listId);

  /// Obtiene una tarjeta por ID
  Future<CardModel?> getCardById(String cardId);

  /// Crea una nueva tarjeta
  Future<CardModel> createCard(
    String title,
    String? description,
    String listId,
    int position, {
    String? assignedToUserId,
    DateTime? dueDate,
    List<String>? labels,
  });

  /// Actualiza una tarjeta
  Future<CardModel> updateCard(
    String cardId,
    String title,
    String? description, {
    String? assignedToUserId,
    DateTime? dueDate,
    List<String>? labels,
  });

  /// Elimina una tarjeta
  Future<void> deleteCard(String cardId);

  /// Mueve una tarjeta a otra posición
  Future<void> moveCard(String cardId, String newListId, int newPosition);
}
