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
    final fenceCount = random.nextInt(7) + 9;
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
      final moves = _getCatMoves(position);
      if (moves.isEmpty) {
        return _MinimaxResult(_evaluateBoard(position), null);
      }
      for (final m in moves) {
        final prevStatePos = position.state;
        final prevStateM = m.state;
        position.state = CellState.empty;
        m.state = CellState.cat;
        final result = _minimax(m, depth - 1, false, alpha, beta);
        m.state = prevStateM;
        position.state = prevStatePos;
        if (result.score > maxEval) {
          maxEval = result.score;
          bestMove = m;
        }
        alpha = max(alpha, maxEval);
        if (beta <= alpha) break;
      }
      return _MinimaxResult(maxEval, bestMove);
    } else {
      double minEval = double.infinity;
      final blocks = _candidateBlocks(position);
      if (blocks.isEmpty) {
        return _MinimaxResult(_evaluateBoard(position), null);
      }
      for (final b in blocks) {
        final prev = b.state;
        b.state = CellState.blocked;
        final result = _minimax(position, depth - 1, true, alpha, beta);
        b.state = prev;
        if (result.score < minEval) {
          minEval = result.score;
        }
        beta = min(beta, minEval);
        if (beta <= alpha) break;
      }
      return _MinimaxResult(minEval, null);
    }
  }

  double _evaluateBoard(CellModel position) {
    if (_isOnEdge(position)) return 100.0;
    if (_isSurrounded(position)) return -100.0;
    final visited = <String>{};
    final q = Queue<MapEntry<CellModel, int>>();
    q.add(MapEntry(position, 0));
    visited.add(_key(position));
    while (q.isNotEmpty) {
      final cur = q.removeFirst();
      final cell = cur.key;
      final d = cur.value;
      if (_isOnEdge(cell) && d > 0) {
        return 50.0 - d.toDouble();
      }
      for (final n in _getPassableNeighbors(cell)) {
        final k = _key(n);
        if (!visited.contains(k)) {
          visited.add(k);
          q.add(MapEntry(n, d + 1));
        }
      }
    }
    return -50.0;
  }

  bool _isOnEdge(CellModel cell) {
    return cell.row == 0 || cell.row == kNumRows - 1 || cell.col == 0 || cell.col == kNumCols - 1;
  }

  bool _isSurrounded(CellModel cell) {
    return _getCatMoves(cell).isEmpty;
  }

  List<CellModel> _getCatMoves(CellModel cell) {
    return _getNeighbors(cell).where((n) => n.state == CellState.empty).toList();
  }

  List<CellModel> _getPassableNeighbors(CellModel cell) {
    return _getNeighbors(cell).where((n) => n.state != CellState.blocked).toList();
  }

  List<CellModel> _getNeighbors(CellModel cell) {
    final r = cell.row;
    final c = cell.col;
    final isEvenRow = r % 2 == 0;
    final directions = isEvenRow
        ? [
            [-1, 0],
            [-1, -1],
            [0, -1],
            [0, 1],
            [1, 0],
            [1, -1]
          ]
        : [
            [-1, 1],
            [-1, 0],
            [0, -1],
            [0, 1],
            [1, 1],
            [1, 0]
          ];
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

  List<CellModel> _candidateBlocks(CellModel position) {
    final limit = 14;
    final setKeys = <String>{};
    final out = <CellModel>[];
    final path = _shortestPathToEdge(position);
    for (final p in path) {
      if (p.state == CellState.empty) {
        final k = _key(p);
        if (setKeys.add(k)) out.add(p);
      }
      for (final n in _getNeighbors(p)) {
        if (n.state == CellState.empty) {
          final k = _key(n);
          if (setKeys.add(k)) out.add(n);
        }
      }
      if (out.length >= limit) return out.take(limit).toList();
    }
    final ring1 = _getNeighbors(position);
    final ring2 = ring1.expand(_getNeighbors);
    for (final n in [...ring1, ...ring2]) {
      if (n.state == CellState.empty) {
        final k = _key(n);
        if (setKeys.add(k)) out.add(n);
        if (out.length >= limit) break;
      }
    }
    return out.length > limit ? out.take(limit).toList() : out;
  }

  List<CellModel> _shortestPathToEdge(CellModel start) {
    final visited = <String>{};
    final parent = <String, String?>{};
    final q = Queue<CellModel>();
    final sk = _key(start);
    q.add(start);
    visited.add(sk);
    parent[sk] = null;
    String? endKey;
    while (q.isNotEmpty) {
      final cur = q.removeFirst();
      if (_isOnEdge(cur) && cur != start) {
        endKey = _key(cur);
        break;
      }
      for (final n in _getPassableNeighbors(cur)) {
        final nk = _key(n);
        if (!visited.contains(nk)) {
          visited.add(nk);
          parent[nk] = _key(cur);
          q.add(n);
        }
      }
    }
    if (endKey == null) return <CellModel>[];
    final path = <CellModel>[];
    String? k = endKey;
    while (k != null) {
      final parts = k.split(',');
      final r = int.parse(parts[0]);
      final c = int.parse(parts[1]);
      path.add(board[r][c]);
      k = parent[k];
    }
    return path.reversed.toList();
  }

  String _key(CellModel c) => '${c.row},${c.col}';
}
