import 'package:flutter/material.dart';
import 'package:typing/model/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState _gameState =
      GameState(id: '', players: [], isJoin: true, isOver: false, words: []);
  Map<String, dynamic> get gamestae => _gameState.toJson();
  void updateGameState(
      {required id,
      required players,
      required isJoin,
      required isOver,
      required words}) {
    _gameState = GameState(
      id: id,
      players: players,
      isJoin: isJoin,
      isOver: isOver,
      words: words,
    );
    notifyListeners();
  }
}
