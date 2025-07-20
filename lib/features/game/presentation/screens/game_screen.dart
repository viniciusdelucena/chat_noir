// lib/features/game/presentation/screens/game_screen.dart

import 'package:chat_noir/features/game/logic/game_logic.dart';
import 'package:chat_noir/features/game/presentation/widgets/hex_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Noir'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Usamos um Consumer aqui para que o placar se atualize
              // automaticamente quando os valores mudarem na GameLogic.
              Consumer<GameLogic>(
                builder: (context, game, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Jogador: ${game.playerScore}'),
                      Text('Gato: ${game.cpuScore}'),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Substituímos o placeholder pelo nosso widget HexBoard!
              const Expanded(
                child: Center( // Center para centralizar o FittedBox
                  child: HexBoard(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  // Acessamos a GameLogic para chamar a função de reset.
                  // O `read` é usado para chamar uma função sem ouvir por mudanças.
                  context.read<GameLogic>().resetGame();
                },
                child: const Text('Resetar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
