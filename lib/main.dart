// lib/main.dart

import 'package:chat_noir/core/theme.dart'; // Importe o tema
import 'package:chat_noir/features/game/presentation/screens/game_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Noir',
      debugShowCheckedModeBanner: false, // Remove a faixa "Debug"
      theme: appTheme, // <<< APLIQUE O TEMA AQUI
      home: const GameScreen(),
    );
  }
}