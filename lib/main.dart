import 'package:chat_noir/core/theme.dart';
import 'package:chat_noir/features/game/logic/game_logic.dart';
import 'package:chat_noir/features/game/presentation/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importe o provider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Envolva o MaterialApp com o ChangeNotifierProvider
    return ChangeNotifierProvider(
      // 3. Crie a instância da sua GameLogic.
      //    Agora, qualquer widget dentro do app pode acessar esta instância.
      create: (context) => GameLogic(),
      child: MaterialApp(
        title: 'Chat Noir',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const GameScreen(),
      ),
    );
  }
}