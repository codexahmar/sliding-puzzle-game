import 'package:flutter/material.dart';

class PuzzleTile extends StatelessWidget {
  final int number;
  final VoidCallback onTap;
  final bool isHint;

  const PuzzleTile({
    super.key,
    required this.number,
    required this.onTap,
    this.isHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isHint ? Colors.yellow : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
      ),
    );
  }
}