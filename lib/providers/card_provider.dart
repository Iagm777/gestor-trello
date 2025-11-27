import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';

/// Provider de Tarjetas
class CardProvider extends ChangeNotifier {
  final CardService _cardService;
  List<CardModel> _cards = [];
  CardModel? _currentCard;
  bool _isLoading = false;
  String? _errorMessage;

  CardProvider(this._cardService);

  // Getters
  List<CardModel> get cards => _cards;
  CardModel? get currentCard => _currentCard;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Obtiene todas las tarjetas de una lista
  Future<void> fetchListCards(String listId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cards = await _cardService.getListCards(listId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea una nueva tarjeta
  Future<void> createCard(
    String title,
    String? description,
    String listId,
    int position, {
    String? assignedToUserId,
    DateTime? dueDate,
    List<String>? labels,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final card = await _cardService.createCard(
        title,
        description,
        listId,
        position,
        assignedToUserId: assignedToUserId,
        dueDate: dueDate,
        labels: labels,
      );
      _cards.add(card);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza una tarjeta
  Future<void> updateCard(
    String cardId,
    String title,
    String? description, {
    String? assignedToUserId,
    DateTime? dueDate,
    List<String>? labels,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final card = await _cardService.updateCard(
        cardId,
        title,
        description,
        assignedToUserId: assignedToUserId,
        dueDate: dueDate,
        labels: labels,
      );
      final index = _cards.indexWhere((c) => c.id == cardId);
      if (index != -1) {
        _cards[index] = card;
      }
      if (_currentCard?.id == cardId) {
        _currentCard = card;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina una tarjeta
  Future<void> deleteCard(String cardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _cardService.deleteCard(cardId);
      _cards.removeWhere((c) => c.id == cardId);
      if (_currentCard?.id == cardId) {
        _currentCard = null;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mueve una tarjeta a otra posición
  Future<void> moveCard(String cardId, String newListId, int newPosition) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _cardService.moveCard(cardId, newListId, newPosition);
      _cards.removeWhere((c) => c.id == cardId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
