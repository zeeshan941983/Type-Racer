import 'package:flutter/material.dart';

import 'package:typing/utils/socket_methods.dart';
import 'package:typing/widgets/custom_button.dart';
import 'package:typing/widgets/custom_textField.dart';

class create_Room extends StatefulWidget {
  const create_Room({super.key});

  @override
  State<create_Room> createState() => _create_RoomState();
}

class _create_RoomState extends State<create_Room> {
  final TextEditingController _nameController = TextEditingController();
  // final SocketClient _socketClient = SocketClient.instance;
  final SocketMethods socketMethods = SocketMethods();
  @override
  void initState() {
    socketMethods.updategameListioner(context);
    socketMethods.notCorrectGame(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // testing() {
  //   _socketClient.socket!.emit('test', "this is working");
  //   _socketClient.socket!.on('connect_error', (error) {
  //     print('Connection error: $error');
  //   });

  //   _socketClient.socket!.on('error', (error) {
  //     print('Socket error: $error');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("object");
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isPhone = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const NetworkImage(
                'https://st2.depositphotos.com/1302980/7215/v/450/depositphotos_72158679-stock-illustration-fantasy-sci-fi-martian-background.jpg',
              ),
              fit: isPhone ? BoxFit.cover : BoxFit.contain,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "join screen",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      custom_textfield(
                        hinttext: 'Enter Your Nickname',
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Custom_button(
                          ontap: () =>
                              socketMethods.createGame(_nameController.text),
                          text: 'Create')
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  }
}
