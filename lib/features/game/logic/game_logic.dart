// lib/features/game/logic/game_logic.dart

import 'package:flutter/foundation.dart';
import 'package:chat_noir/core/constants.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';
import 'dart:math'; // Precisaremos do 'dart:math' para a lógica de placeFences

class GameLogic extends ChangeNotifier {
  // ... (todo o código anterior: placar, tabuleiro, etc.) ...
  int _playerScore = 0;
  int get playerScore => _playerScore;

  int _cpuScore = 0;
  int get cpuScore => _cpuScore;

  late List<List<CellModel>> board;
  late CellModel catPosition;

  GameLogic() {
    resetGame();
  }

  void resetGame() {
    board = List.generate(
      kNumRows,
      (r) => List.generate(
        kNumCols,
        (c) => CellModel(row: r, col: c),
      ),
    );

    const catInitialRow = 5;
    const catInitialCol = 5;
    catPosition = board[catInitialRow][catInitialCol];
    catPosition.state = CellState.cat;

    _placeInitialFences();

    notifyListeners();
  }

  // Esta é a tradução da sua função `placeFences`
  void _placeInitialFences() {
    final random = Random();
    // Gera entre 12 e 18 obstáculos
    final fenceCount = random.nextInt(7) + 12;
    int placed = 0;

    while (placed < fenceCount) {
      final r = random.nextInt(kNumRows);
      final c = random.nextInt(kNumCols);
      final cell = board[r][c];

      // Garante que não coloque um obstáculo na posição do gato ou onde já existe um
      if (cell.state == CellState.empty) {
        cell.state = CellState.blocked;
        placed++;
      }
    }
  }

  // =======================================================================
  // NOVO MÉTODO: LÓGICA DO CLIQUE (Tradução de handlePlayerClick)
  // =======================================================================
  void handlePlayerClick(int row, int col) {
    final clickedCell = board[row][col];

    // Regra 1: Não faz nada se o jogador clicar na célula do gato.
    if (clickedCell.state == CellState.cat) {
      print("Não pode clicar no gato!");
      return;
    }

    // Regra 2: Não faz nada se a célula já estiver bloqueada.
    if (clickedCell.state == CellState.blocked) {
      print("Esta célula já está bloqueada!");
      return;
    }

    // Se o movimento for válido:
    // 1. Bloqueia a célula clicada.
    clickedCell.state = CellState.blocked;

    // 2. Aciona a jogada da CPU (o gato).
    //    (Por enquanto, vamos apenas imprimir uma mensagem. A IA virá a seguir).
    _cpuMove();

    // 3. Notifica a interface para se redesenhar com a célula bloqueada.
    notifyListeners();
  }

  void _cpuMove() {
    // TODO: Implementar a lógica do Minimax da função cpuMove() do JS aqui.
    print("É a vez do gato se mover!");
  }
  // =======================================================================
}