import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing/provider/client_state.dart';

import 'package:typing/utils/socket_client.dart';

import '../provider/game_state_provider.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isplaying = false;
  //create game funtion
  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('create-game', {
        'nickname': nickname,
      });
    }
  }

//join game
  joinGame(String nickname, String gameId) {
    if (nickname.isNotEmpty && gameId.isNotEmpty) {
      _socketClient.emit('join-game', {
        'nickname': nickname,
        'gameId': gameId,
      });
    }
  }

  ///update data
  updategameListioner(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      print(data);
      // ignore: unused_local_variable
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
        id: data['_id'],
        players: data["players"],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
        words: data['words'],
      );
      if (data['_id'] != null && !_isplaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isplaying = true;
      }
    });
  }

  //error
  notCorrectGame(BuildContext context) {
    _socketClient.on(
        'notCorrectGame',
        (data) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data))));
  }

  //start time
  startTimer(playerId, gameId) {
    _socketClient.emit('timer', {
      'playerId': playerId,
      'gameId': gameId,
    });
  }

  //update timer
  updateTimer(BuildContext context) {
    final clientstateProvider =
        Provider.of<ClientStateProvider>(context, listen: false);
    _socketClient.on(
        'timer', (data) => {clientstateProvider.setClientState(data)});
  }

  sendUserInput(String value, String gameId) {
    _socketClient.emit('userInput', {
      "userInput": value,
      "gameId": gameId,
    });
  }

  gameFinishListner() {
    _socketClient.on('done', (data) => _socketClient.off('timer'));
  }
}
