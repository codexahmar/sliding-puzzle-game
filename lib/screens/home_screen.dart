import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_state.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sliding Puzzle',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 60),
                _buildGridSizeOption(context, 3, '3 x 3'),
                const SizedBox(height: 16),
                _buildGridSizeOption(context, 4, '4 x 4'),
                const SizedBox(height: 16),
                _buildGridSizeOption(context, 5, '5 x 5'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridSizeOption(BuildContext context, int size, String label) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => PuzzleState(gridSize: size),
                child: const GameScreen(),
              ),
            ),
          );
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
