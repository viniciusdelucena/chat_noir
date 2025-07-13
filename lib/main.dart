import 'package:flutter/material.dart';
import 'package:chat_noir/features/game/presentation/screens/game_screen.dart'; // Importe a nova tela

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Noir Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(), // Sua tela principal agora é GameScreen
    );
  }
}