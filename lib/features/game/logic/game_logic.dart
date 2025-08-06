import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:chat_noir/core/constants.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';

// Enum para controlar o estado da partida
enum GameStatus { playing, playerWon, catWon }

// Classe auxiliar para o resultado do Minimax
class _MinimaxResult {
  final double score;
  final CellModel? move;
  _MinimaxResult(this.score, this.move);
}

class GameLogic extends ChangeNotifier {
  int _playerScore = 0;
  int get playerScore => _playerScore;

  int _cpuScore = 0;
  int get cpuScore => _cpuScore;

  late List<List<CellModel>> board;
  late CellModel catPosition;
  
  // Novo estado para controlar o fim do jogo
  GameStatus _gameStatus = GameStatus.playing;
  GameStatus get gameStatus => _gameStatus;

  GameLogic() {
    resetGame();
  }

  void resetGame() {
    _gameStatus = GameStatus.playing;
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

  void _placeInitialFences() {
    final random = Random();
    final fenceCount = random.nextInt(7) + 12;
    int placed = 0;
    while (placed < fenceCount) {
      final r = random.nextInt(kNumRows);
      final c = random.nextInt(kNumCols);
      final cell = board[r][c];
      if (cell.state == CellState.empty) {
        cell.state = CellState.blocked;
        placed++;
      }
    }
  }

  void handlePlayerClick(int row, int col) {
    // Só permite jogar se a partida estiver a decorrer
    if (_gameStatus != GameStatus.playing) return;

    final clickedCell = board[row][col];
    if (clickedCell.state == CellState.cat || clickedCell.state == CellState.blocked) {
      return;
    }

    clickedCell.state = CellState.blocked;
    notifyListeners(); // Atualiza a UI para mostrar a célula bloqueada

    // Atraso para dar a sensação de que o gato está a "pensar"
    Future.delayed(const Duration(milliseconds: 300), () {
      _cpuMove();
    });
  }

  // =======================================================================
  // LÓGICA DA IA (Tradução de cpuMove, minimax, etc.)
  // =======================================================================

  void _cpuMove() {
    // A IA só joga se a partida estiver a decorrer
    if (_gameStatus != GameStatus.playing) return;

    const depth = 3; // Profundidade da análise do Minimax
    final bestMoveResult = _minimax(catPosition, depth, true, -double.infinity, double.infinity);

    if (bestMoveResult.move != null) {
      // Move o gato para a melhor posição encontrada
      catPosition.state = CellState.empty;
      catPosition = bestMoveResult.move!;
      catPosition.state = CellState.cat;

      // Verifica se o gato ganhou
      if (_isOnEdge(catPosition)) {
        _gameStatus = GameStatus.catWon;
        _cpuScore++;
      }
    } else {
      // Se não há movimentos, o jogador ganhou
      _gameStatus = GameStatus.playerWon;
      _playerScore++;
    }
    notifyListeners();
  }

  _MinimaxResult _minimax(CellModel position, int depth, bool maximizing, double alpha, double beta) {
    if (depth == 0 || _isOnEdge(position) || _isSurrounded(position)) {
      return _MinimaxResult(_evaluateBoard(position), null);
    }

    if (maximizing) { // O gato (maximizador) tenta encontrar o melhor movimento
      double maxEval = -double.infinity;
      CellModel? bestMove;
      for (final neighbor in _getAvailableNeighbors(position)) {
        final result = _minimax(neighbor, depth - 1, false, alpha, beta);
        if (result.score > maxEval) {
          maxEval = result.score;
          bestMove = neighbor;
        }
        alpha = max(alpha, maxEval);
        if (beta <= alpha) break; // Poda Alpha-Beta
      }
      return _MinimaxResult(maxEval, bestMove);
    } else { // O jogador (minimizador) é simulado para bloquear
      double minEval = double.infinity;
      // Esta parte é uma simplificação. Uma simulação completa do bloqueio
      // seria muito pesada. A avaliação do tabuleiro já lida com isto implicitamente.
      for (final neighbor in _getAvailableNeighbors(position)) {
         final result = _minimax(neighbor, depth - 1, true, alpha, beta);
         minEval = min(minEval, result.score);
         beta = min(beta, minEval);
         if (beta <= alpha) break; // Poda Alpha-Beta
      }
      return _MinimaxResult(minEval, null);
    }
  }

  // Avalia a posição: um valor alto é bom para o gato, baixo é mau.
  double _evaluateBoard(CellModel position) {
    if (_isOnEdge(position)) return 100.0; // Vitória
    if (_isSurrounded(position)) return -100.0; // Derrota

    // Usa BFS (Busca em Largura) para encontrar a distância mais curta até à borda
    final queue = Queue<List<CellModel>>()..add([position]);
    final visited = {position};

    int distance = 0;
    while(queue.isNotEmpty){
        distance++;
        final path = queue.removeFirst();
        final lastNode = path.last;
        for(final neighbor in _getAvailableNeighbors(lastNode)){
            if(!visited.contains(neighbor)){
                // CORREÇÃO: Garante que o retorno seja um double.
                if(_isOnEdge(neighbor)) return 50.0 - distance; // Quanto mais perto da borda, melhor
                visited.add(neighbor);
                final newPath = List<CellModel>.from(path)..add(neighbor);
                queue.add(newPath);
            }
        }
    }
    return -50.0; // Não deveria chegar aqui, mas significa que está preso
  }

  bool _isOnEdge(CellModel cell) {
    return cell.row == 0 || cell.row == kNumRows - 1 || cell.col == 0 || cell.col == kNumCols - 1;
  }

  bool _isSurrounded(CellModel cell) {
    return _getAvailableNeighbors(cell).isEmpty;
  }

  List<CellModel> _getAvailableNeighbors(CellModel cell) {
    return _getNeighbors(cell).where((n) => n.state != CellState.blocked).toList();
  }

  List<CellModel> _getNeighbors(CellModel cell) {
    final r = cell.row;
    final c = cell.col;
    final isEvenRow = r % 2 == 0;
    final directions = isEvenRow
        ? [[-1, 0], [-1, -1], [0, -1], [0, 1], [1, 0], [1, -1]]
        : [[-1, 1], [-1, 0], [0, -1], [0, 1], [1, 1], [1, 0]];

    final neighbors = <CellModel>[];
    for (final dir in directions) {
      final newRow = r + dir[0];
      final newCol = c + dir[1];
      if (newRow >= 0 && newRow < kNumRows && newCol >= 0 && newCol < kNumCols) {
        neighbors.add(board[newRow][newCol]);
      }
    }
    return neighbors;
  }
}
