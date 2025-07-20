// lib/features/game/logic/game_logic.dart

import 'package:flutter/foundation.dart';
import 'package:chat_noir/core/constants.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';

class GameLogic extends ChangeNotifier {
  // ESTADO DO JOGO
  // =============================================

  // Placar do jogador e da CPU.
  int _playerScore = 0;
  int get playerScore => _playerScore;

  int _cpuScore = 0;
  int get cpuScore => _cpuScore;

  // O tabuleiro do jogo, representado por uma lista de listas de células.
  late List<List<CellModel>> board;

  // Posição atual do gato.
  late CellModel catPosition;

  // =============================================

  // CONSTRUTOR
  // =============================================
  GameLogic() {
    resetGame();
  }
  // =============================================


  // LÓGICA INICIAL (Tradução de createBoard e resetGame)
  // =============================================

  void resetGame() {
    // 1. Cria um tabuleiro vazio.
    // Isto corresponde ao loop dentro de `createBoard()` no seu JS.
    board = List.generate(
      kNumRows,
      (r) => List.generate(
        kNumCols,
        (c) => CellModel(row: r, col: c),
      ),
    );

    // 2. Define a posição inicial do gato.
    // Corresponde a `let catPos = { row: 5, col: 5 };`
    const catInitialRow = 5;
    const catInitialCol = 5;
    catPosition = board[catInitialRow][catInitialCol];
    catPosition.state = CellState.cat;

    // 3. Coloca as cercas/obstáculos iniciais.
    // (A lógica de `placeFences` virá depois, por enquanto só preparamos o terreno)
    _placeInitialFences();

    // 4. Notifica a interface que o estado mudou e ela precisa se redesenhar.
    notifyListeners();
  }

  void _placeInitialFences() {
    // TODO: Implementar a lógica da função placeFences() do JS aqui.
    print("Obstáculos iniciais serão colocados aqui.");
  }

  // =============================================
}