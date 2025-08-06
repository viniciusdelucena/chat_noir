import 'package:chat_noir/features/game/logic/game_logic.dart';
import 'package:chat_noir/features/game/presentation/widgets/hex_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HexBoard extends StatelessWidget {
  const HexBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui, usamos `context.read` para obter a instância da GameLogic
    // para podermos chamar a função de clique.
    final gameLogic = context.read<GameLogic>();

    // Usamos `Consumer` para que o tabuleiro se reconstrua quando o estado mudar.
    return Consumer<GameLogic>(
      builder: (context, game, child) {
        return FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(game.board.length, (r) {
              final row = game.board[r];
              return Padding(
                padding: EdgeInsets.only(left: r % 2 != 0 ? 26.0 : 0.0),
                child: Row(
                  children: List.generate(row.length, (c) {
                    final cell = row[c];
                    return HexCell(
                      cell: cell,
                      // A MUDANÇA ESTÁ AQUI:
                      // Agora, o onTap chama o nosso novo método na GameLogic.
                      onTap: () => gameLogic.handlePlayerClick(cell.row, cell.col),
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