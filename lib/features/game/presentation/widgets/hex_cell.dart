import 'package:chat_noir/core/styles/colors.dart';
import 'package:chat_noir/features/game/data/cell_model.dart';
import 'package:chat_noir/features/game/presentation/widgets/hex_clipper.dart';
import 'package:flutter/material.dart';

class HexCell extends StatelessWidget {
  final CellModel cell;
  final VoidCallback onTap; 

  const HexCell({
    super.key,
    required this.cell,
    required this.onTap,
  });

  Color _getColorForState(CellState state) {
    switch (state) {
      case CellState.empty:
        return AppColors.cell; 
      case CellState.blocked:
        return AppColors.cellBlocked; 
      case CellState.cat:
        return AppColors.cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: HexClipper(), 
        child: Container(
          color: _getColorForState(cell.state),
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
