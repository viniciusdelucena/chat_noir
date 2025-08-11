import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:chat_noir/core/constants.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';

enum GameStatus { playing, playerWon, catWon }

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
    if (_gameStatus != GameStatus.playing) return;

    final clickedCell = board[row][col];
    if (clickedCell.state == CellState.cat || clickedCell.state == CellState.blocked) {
      return;
    }

    clickedCell.state = CellState.blocked;
    notifyListeners(); 

    Future.delayed(const Duration(milliseconds: 300), () {
      _cpuMove();
    });
  }

  void _cpuMove() {
    if (_gameStatus != GameStatus.playing) return;

    const depth = 3; 
    final bestMoveResult = _minimax(catPosition, depth, true, -double.infinity, double.infinity);

    if (bestMoveResult.move != null) {
      catPosition.state = CellState.empty;
      catPosition = bestMoveResult.move!;
      catPosition.state = CellState.cat;

      if (_isOnEdge(catPosition)) {
        _gameStatus = GameStatus.catWon;
        _cpuScore++;
      }
    } else {
      _gameStatus = GameStatus.playerWon;
      _playerScore++;
    }
    notifyListeners();
  }

  _MinimaxResult _minimax(CellModel position, int depth, bool maximizing, double alpha, double beta) {
    if (depth == 0 || _isOnEdge(position) || _isSurrounded(position)) {
      return _MinimaxResult(_evaluateBoard(position), null);
    }

    if (maximizing) { 
      double maxEval = -double.infinity;
      CellModel? bestMove;
      for (final neighbor in _getAvailableNeighbors(position)) {
        final result = _minimax(neighbor, depth - 1, false, alpha, beta);
        if (result.score > maxEval) {
          maxEval = result.score;
          bestMove = neighbor;
        }
        alpha = max(alpha, maxEval);
        if (beta <= alpha) break; 
      }
      return _MinimaxResult(maxEval, bestMove);
    } else { 
      double minEval = double.infinity;

      for (final neighbor in _getAvailableNeighbors(position)) {
         final result = _minimax(neighbor, depth - 1, true, alpha, beta);
         minEval = min(minEval, result.score);
         beta = min(beta, minEval);
         if (beta <= alpha) break; 
      }
      return _MinimaxResult(minEval, null);
    }
  }

  double _evaluateBoard(CellModel position) {
    if (_isOnEdge(position)) return 100.0; 
    if (_isSurrounded(position)) return -100.0; 

    final queue = Queue<List<CellModel>>()..add([position]);
    final visited = {position};

    int distance = 0;
    while(queue.isNotEmpty){
        distance++;
        final path = queue.removeFirst();
        final lastNode = path.last;
        for(final neighbor in _getAvailableNeighbors(lastNode)){
            if(!visited.contains(neighbor)){
                if(_isOnEdge(neighbor)) return 50.0 - distance;
                visited.add(neighbor);
                final newPath = List<CellModel>.from(path)..add(neighbor);
                queue.add(newPath);
            }
        }
    }
    return -50.0;
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
