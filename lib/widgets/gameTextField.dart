import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing/provider/game_state_provider.dart';
import 'package:typing/utils/socket_client.dart';
import 'package:typing/utils/socket_methods.dart';
import 'package:typing/widgets/custom_button.dart';

class GametextField extends StatefulWidget {
  const GametextField({super.key});

  @override
  State<GametextField> createState() => _GametextFieldState();
}

class _GametextFieldState extends State<GametextField> {
  final SocketMethods socketMethods = SocketMethods();
  final TextEditingController gameController = TextEditingController();
  var playerMe = null;
  bool isbtn = true;
  late GameStateProvider? game;
  @override
  void initState() {
    game = Provider.of<GameStateProvider>(context, listen: false);
    super.initState();
    findPlayerMe(game!);
  }

  findPlayerMe(GameStateProvider game) {
    game.gamestae['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

//client -> server (start timer)
  handleStart(GameStateProvider game) {
    socketMethods.startTimer(playerMe['_id'], game.gamestae['id']);
    setState(() {
      isbtn = !isbtn;
    });
  }

  //handle text chnages
  handleTextchange(String value, String gameId) {
    var lastChar = value[value.length - 1];
    if (lastChar == ' ') {
      socketMethods.sendUserInput(value, gameId);
      setState(() {
        gameController.text = " ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamedata = Provider.of<GameStateProvider>(context);
    return playerMe['isPartyLeader'] && isbtn
        ? Custom_button(ontap: () => handleStart(gamedata), text: 'Start')
        : TextFormField(
            controller: gameController,
            readOnly: gamedata.gamestae['isJoin'],
            onChanged: (val) => handleTextchange(val, gamedata.gamestae['id']),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                fillColor: Color(0xffF5F5FA),
                filled: true,
                hintText: 'Enter something',
                hintStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          );
  }
}
