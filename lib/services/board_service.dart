import '../models/board_model.dart';

/// Servicio de Tableros
abstract class BoardService {
  /// Obtiene todos los tableros del usuario
  Future<List<BoardModel>> getUserBoards(String userId);

  /// Obtiene un tablero por ID
  Future<BoardModel?> getBoardById(String boardId);

  /// Crea un nuevo tablero
  Future<BoardModel> createBoard(String title, String? description, String userId);

  /// Actualiza un tablero
  Future<BoardModel> updateBoard(String boardId, String title, String? description);

  /// Elimina un tablero
  Future<void> deleteBoard(String boardId);
}
