enum CellState { empty, blocked, cat }

class CellModel {
  final int row;
  final int col;

  CellState state;

  CellModel({
    required this.row,
    required this.col,
    this.state = CellState.empty,
  });

  @override
  String toString() {
    return 'Cell($row, $col, $state)';
  }
}