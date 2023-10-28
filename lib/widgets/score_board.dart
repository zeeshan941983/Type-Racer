import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing/provider/game_state_provider.dart';
import 'package:typing/utils/socket_client.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  var playerMe = null;
  @override
  void initState() {
    final game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game);
    super.initState();
  }

  findPlayerMe(GameStateProvider game) {
    game.gamestae['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player['nickname'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: game.gamestae['players'].length,
        itemBuilder: (context, index) {
          var playerData = game.gamestae['players'][index];
          return ListTile(
            title: playerMe == playerData['nickname']
                ? const Text("You")
                : Text(playerData['nickname']),
            trailing: Text("WPM ${playerData['WPM']}"),
          );
        });
  }
}
