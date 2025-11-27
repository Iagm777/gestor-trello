import 'package:flutter/material.dart';
import '../models/list_model.dart';
import '../services/list_service.dart';

/// Provider de Listas
class ListProvider extends ChangeNotifier {
  final ListService _listService;
  List<ListModel> _lists = [];
  bool _isLoading = false;
  String? _errorMessage;

  ListProvider(this._listService);

  // Getters
  List<ListModel> get lists => _lists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Obtiene todas las listas de un tablero
  Future<void> fetchBoardLists(String boardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lists = await _listService.getBoardLists(boardId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea una nueva lista
  Future<void> createList(String title, String boardId, int position) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await _listService.createList(title, boardId, position);
      _lists.add(list);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza una lista
  Future<void> updateList(String listId, String title, int position) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await _listService.updateList(listId, title, position);
      final index = _lists.indexWhere((l) => l.id == listId);
      if (index != -1) {
        _lists[index] = list;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina una lista
  Future<void> deleteList(String listId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _listService.deleteList(listId);
      _lists.removeWhere((l) => l.id == listId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
