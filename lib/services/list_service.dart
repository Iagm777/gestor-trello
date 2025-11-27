import '../models/list_model.dart';

/// Servicio de Listas
abstract class ListService {
  /// Obtiene todas las listas de un tablero
  Future<List<ListModel>> getBoardLists(String boardId);

  /// Obtiene una lista por ID
  Future<ListModel?> getListById(String listId);

  /// Crea una nueva lista
  Future<ListModel> createList(String title, String boardId, int position);

  /// Actualiza una lista
  Future<ListModel> updateList(String listId, String title, int position);

  /// Elimina una lista
  Future<void> deleteList(String listId);
}
