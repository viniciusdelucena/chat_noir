// lib/features/game/presentation/widgets/hex_board.dart

import 'package:chat_noir/features/game/logic/game_logic.dart';
import 'package:chat_noir/features/game/presentation/widgets/hex_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HexBoard extends StatelessWidget {
  const HexBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos `Consumer` para acessar a `GameLogic` e reconstruir o widget
    // sempre que `notifyListeners()` for chamado.
    return Consumer<GameLogic>(
      builder: (context, game, child) {
        // O `FittedBox` garante que o tabuleiro se ajuste ao espaço disponível,
        // encolhendo se necessário, mas mantendo a proporção.
        return FittedBox(
          child: Column(
            // Este `Column` representa o `<div id="game-board">`
            mainAxisSize: MainAxisSize.min,
            children: List.generate(game.board.length, (r) {
              final row = game.board[r];
              // Este `Row` representa o `<div class="row">`
              return Padding(
                // Aqui aplicamos o deslocamento para as linhas ímpares,
                // traduzindo a classe CSS `.row.offset`.
                padding: EdgeInsets.only(left: r % 2 != 0 ? 26.0 : 0.0),
                child: Row(
                  children: List.generate(row.length, (c) {
                    final cell = row[c];
                    return HexCell(
                      cell: cell,
                      onTap: () {
                        // Ação de clique será implementada depois.
                        print('Clicou na célula (${cell.row}, ${cell.col})');
                      },
                    );
                  }),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
