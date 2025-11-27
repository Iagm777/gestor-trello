import 'package:flutter/material.dart';
import '../models/board_model.dart';
import '../services/board_service.dart';

/// Provider de Tableros
class BoardProvider extends ChangeNotifier {
  final BoardService _boardService;
  List<BoardModel> _boards = [];
  BoardModel? _currentBoard;
  bool _isLoading = false;
  String? _errorMessage;

  BoardProvider(this._boardService);

  // Getters
  List<BoardModel> get boards => _boards;
  BoardModel? get currentBoard => _currentBoard;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Obtiene todos los tableros del usuario
  Future<void> fetchUserBoards(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _boards = await _boardService.getUserBoards(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene un tablero por ID
  Future<void> fetchBoardById(String boardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBoard = await _boardService.getBoardById(boardId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea un nuevo tablero
  Future<void> createBoard(String title, String? description, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final board = await _boardService.createBoard(title, description, userId);
      _boards.add(board);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza un tablero
  Future<void> updateBoard(String boardId, String title, String? description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final board = await _boardService.updateBoard(boardId, title, description);
      final index = _boards.indexWhere((b) => b.id == boardId);
      if (index != -1) {
        _boards[index] = board;
      }
      if (_currentBoard?.id == boardId) {
        _currentBoard = board;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina un tablero
  Future<void> deleteBoard(String boardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _boardService.deleteBoard(boardId);
      _boards.removeWhere((b) => b.id == boardId);
      if (_currentBoard?.id == boardId) {
        _currentBoard = null;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
