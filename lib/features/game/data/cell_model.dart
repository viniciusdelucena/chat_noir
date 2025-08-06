// Define os possíveis estados de uma célula.
// Usar um enum é muito mais seguro e legível do que usar strings ou classes.
enum CellState { empty, blocked, cat }

class CellModel {
  // Posição da célula no tabuleiro.
  final int row;
  final int col;

  // O estado atual da célula (vazia, bloqueada ou com o gato).
  CellState state;

  CellModel({
    required this.row,
    required this.col,
    this.state = CellState.empty,
  });

  // Método auxiliar para facilitar a depuração.
  @override
  String toString() {
    return 'Cell($row, $col, $state)';
  }
}