import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_state.dart';

class GameStats extends StatelessWidget {
  const GameStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleState>(
      builder: (context, puzzleState, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Moves',
                puzzleState.moves.toString(),
                Icons.swap_horiz,
              ),
              _buildStatCard(
                'Time',
                puzzleState.timeElapsed,
                Icons.timer,
              ),
              _buildStatCard(
                'Hints',
                puzzleState.hintsRemaining.toString(),
                Icons.lightbulb_outline,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}