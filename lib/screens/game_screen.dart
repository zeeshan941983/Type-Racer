import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:typing/provider/client_state.dart';
import 'package:typing/provider/game_state_provider.dart';
import 'package:typing/utils/socket_client.dart';
import 'package:typing/utils/socket_methods.dart';
import 'package:typing/widgets/gameTextField.dart';
import 'package:typing/widgets/indicator.dart';
import 'package:typing/widgets/sentance_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();
  var playerMe = null;

  @override
  void initState() {
    _socketMethods.updateTimer(context);
    final game = Provider.of<GameStateProvider>(context, listen: false);
    _socketMethods.gameFinishListner();

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
    final clientstateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xffB3E9C7),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Chip(
                label: Text(clientstateProvider.clientstate['timer']['msg']
                    .toString())),
            Chip(
              label: Text(
                clientstateProvider.clientstate['timer']['countdown']
                    .toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SentenceGame(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: game.gamestae['players'].length,
                itemBuilder: (context, index) {
                  final player = game.gamestae['players'][index];
                  final isCurrentUser = playerMe == player['nickname'];

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        isCurrentUser
                            ? const Text(
                                'You',
                                style: TextStyle(fontSize: 18),
                              )
                            : Text(
                                player['nickname'],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        PercentageIndicator(
                          player['currentWordIndex'] /
                              game.gamestae['words'].length,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            game.gamestae['isJoin']
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: game.gamestae['id']))
                            .then((_) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content:
                                        Text("Text copyied Successfully"))));
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          fillColor: Color(0xffF5F5FA),
                          filled: true,
                          hintText: "Copy Game Id",
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                  )
                : Container(),
          ],
        ),
      )),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: const GametextField()),
    );
  }
}
