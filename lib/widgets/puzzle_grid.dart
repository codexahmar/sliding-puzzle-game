import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_state.dart';
import 'puzzle_tile.dart';

class PuzzleGrid extends StatelessWidget {
  const PuzzleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          child: Consumer<PuzzleState>(
            builder: (context, puzzleState, _) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: puzzleState.gridSize,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: puzzleState.gridSize * puzzleState.gridSize,
                itemBuilder: (context, index) {
                  final row = index ~/ puzzleState.gridSize;
                  final col = index % puzzleState.gridSize;
                  final number = puzzleState.grid[row][col];

                  if (number == null) return const SizedBox.shrink();

                  return PuzzleTile(
                    number: number,
                    isHint: number == puzzleState.hintTile,
                    onTap: () => puzzleState.moveTile(
                        row, col, context), // Pass context here
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
