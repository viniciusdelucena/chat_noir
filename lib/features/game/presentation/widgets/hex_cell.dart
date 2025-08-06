import 'package:chat_noir/core/styles/colors.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';
import 'package:chat_noir/features/game/presentation/widgets/hex_clipper.dart';
import 'package:flutter/material.dart';

class HexCell extends StatelessWidget {
  final CellModel cell;
  final VoidCallback onTap; // Função a ser chamada no clique

  const HexCell({
    super.key,
    required this.cell,
    required this.onTap,
  });

  // Esta função escolhe a cor correta baseada no estado da célula.
  // É a tradução das suas classes CSS: .cell, .cell.blocked, .cell.cat
  Color _getColorForState(CellState state) {
    switch (state) {
      case CellState.empty:
        return AppColors.cell; // Cor padrão
      case CellState.blocked:
        return AppColors.cellBlocked; // Cor quando bloqueada
      case CellState.cat:
        return AppColors.cat; // Cor quando o gato está aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector detecta toques, como o `onclick` do JavaScript.
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: HexClipper(), // Usa o recortador que criamos
        child: Container(
          // Define a cor baseada no estado da célula
          color: _getColorForState(cell.state),
          // O tamanho da célula, vindo do seu CSS: width: 50px, height: 50px
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
