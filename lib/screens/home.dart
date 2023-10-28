import 'package:flutter/material.dart';

import 'package:typing/widgets/custom_button.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPhone = constraints.maxWidth < 600;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://st2.depositphotos.com/1302980/7215/v/450/depositphotos_72158679-stock-illustration-fantasy-sci-fi-martian-background.jpg',
                ),
                fit: isPhone ? BoxFit.cover : BoxFit.contain,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Create/Join Room to Play",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Custom_button(
                        ishome: true,
                        ontap: () =>
                            Navigator.pushNamed(context, '/create-room'),
                        text: 'Create'),
                    const SizedBox(
                      height: 20,
                    ),
                    Custom_button(
                        ishome: true,
                        ontap: () => Navigator.pushNamed(context, '/join-room'),
                        text: 'Join')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
