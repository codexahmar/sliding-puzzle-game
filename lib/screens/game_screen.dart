import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_state.dart';
import '../widgets/puzzle_grid.dart';

import '../widgets/game_stats.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[800]),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[800]),
            onPressed: () => context.read<PuzzleState>().initializeGame(),
          ),
          IconButton(
            icon: Icon(Icons.lightbulb_outline, color: Colors.blue[800]),
            onPressed: () => context.read<PuzzleState>().getHint(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const GameStats(),
            const SizedBox(height: 20),
            const Expanded(
              child: PuzzleGrid(), // Using the extracted widget here
            ),
          ],
        ),
      ),
    );
  }
}
