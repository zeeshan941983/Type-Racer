import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing/provider/client_state.dart';
import 'package:typing/provider/game_state_provider.dart';
import 'package:typing/screens/create.dart';
import 'package:typing/screens/game_screen.dart';
import 'package:typing/screens/home.dart';
import 'package:typing/screens/join.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameStateProvider()),
        ChangeNotifierProvider(create: (context) => ClientStateProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Type Racer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const home(),
          '/create-room': (context) => const create_Room(),
          '/join-room': (context) => const join_Room(),
          '/game-screen': (context) => const GameScreen(),
        },
      ),
    );
  }
}
