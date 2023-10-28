import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing/provider/game_state_provider.dart';
import 'package:typing/utils/socket_client.dart';
import 'package:typing/utils/socket_methods.dart';
import 'package:typing/widgets/score_board.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  var playerMe = null;
  final SocketMethods socketMethods = SocketMethods();
  findPlayerMe(GameStateProvider game) {
    game.gamestae['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  Widget getTypedWords(words, player) {
    var tempWords = words.sublist(0, player['currentWordIndex']);
    String typeWord = tempWords.join(' ');
    return Text(
      typeWord,
      style: TextStyle(color: Colors.green, fontSize: 30),
    );
  }

  Widget getTcurrentWords(words, player) {
    return Text(
      words[player['currentWordIndex']],
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getTWordstoBeTypeWords(words, player) {
    var tempWords = words.sublist(player['currentWordIndex'] + 1, words.length);
    String WordsToBeTyped = tempWords.join(' ');
    return Text(
      WordsToBeTyped,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayerMe(game);
    if (game.gamestae['words'].length > playerMe['currentWordIndex']) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          textDirection: TextDirection.ltr,
          children: [
            //type words
            getTypedWords(game.gamestae['words'], playerMe),
            //current word
            getTcurrentWords(game.gamestae['words'], playerMe),
            //word to be typed
            getTWordstoBeTypeWords(game.gamestae['words'], playerMe)
          ],
        ),
      );
    }

    return const Scoreboard();
  }
}
