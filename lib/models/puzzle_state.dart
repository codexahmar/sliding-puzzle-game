import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../widgets/win_dialog.dart';
import 'position.dart';

class PuzzleState extends ChangeNotifier {
  late List<List<int?>> grid;
  late Position emptyPosition;
  int moves = 0;
  late Stopwatch stopwatch;
  late Timer timer;
  String timeElapsed = '00:00';
  int? hintTile;
  int hintsRemaining = 10;
  final int gridSize;
  bool isGameComplete = false;

  PuzzleState({required this.gridSize}) {
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
    initializeGame();
  }

  void _updateTime(Timer timer) {
    if (stopwatch.isRunning) {
      final minutes = stopwatch.elapsed.inMinutes;
      final seconds = stopwatch.elapsed.inSeconds % 60;
      timeElapsed =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      notifyListeners();
    }
  }

// Add this method to your PuzzleState class
  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WinDialog(
        moves: moves,
        time: timeElapsed,
        onRestart: () {
          Navigator.pop(context);
          initializeGame();
        },
        onHome: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  void initializeGame() {
    moves = 0;
    stopwatch.reset();
    stopwatch.start();
    hintsRemaining = 10;
    hintTile = null;
    isGameComplete = false;

    // Create solved grid
    grid = List.generate(
      gridSize,
      (i) => List.generate(
        gridSize,
        (j) => i * gridSize + j + 1,
      ),
    );
    grid[gridSize - 1][gridSize - 1] = null;
    emptyPosition = Position(gridSize - 1, gridSize - 1);

    _shufflePuzzle();
    notifyListeners();
  }

  void _shufflePuzzle() {
    final random = Random();
    List<List<int?>> tempGrid = List.generate(
      gridSize,
      (i) => List.generate(
        gridSize,
        (j) => grid[i][j],
      ),
    );
    Position tempEmpty = Position(emptyPosition.row, emptyPosition.col);

    for (int i = 0; i < 100; i++) {
      final validMoves = _getValidMovesForPosition(tempEmpty);
      final move = validMoves[random.nextInt(validMoves.length)];

      final temp = tempGrid[tempEmpty.row][tempEmpty.col];
      tempGrid[tempEmpty.row][tempEmpty.col] = tempGrid[move.row][move.col];
      tempGrid[move.row][move.col] = temp;
      tempEmpty = move;
    }

    grid = tempGrid;
    emptyPosition = tempEmpty;
    notifyListeners();
  }

  List<Position> _getValidMovesForPosition(Position pos) {
    final List<Position> validMoves = [];
    final directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ];

    for (final direction in directions) {
      final newRow = pos.row + direction[0];
      final newCol = pos.col + direction[1];

      if (newRow >= 0 &&
          newRow < gridSize &&
          newCol >= 0 &&
          newCol < gridSize) {
        validMoves.add(Position(newRow, newCol));
      }
    }
    return validMoves;
  }

  bool _isValidMove(int row, int col) {
    return (row == emptyPosition.row && (col - emptyPosition.col).abs() == 1) ||
        (col == emptyPosition.col && (row - emptyPosition.row).abs() == 1);
  }

  void moveTile(int row, int col, BuildContext context) {
    // Add context parameter
    if (_isValidMove(row, col)) {
      grid[emptyPosition.row][emptyPosition.col] = grid[row][col];
      grid[row][col] = null;
      emptyPosition = Position(row, col);
      moves++;

      if (_checkWin()) {
        stopwatch.stop();
        isGameComplete = true;
        _showWinDialog(context); // Show dialog when game is won
      }
      notifyListeners();
    }
  }

  bool _checkWin() {
    int expectedValue = 1;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (i == gridSize - 1 && j == gridSize - 1) {
          return grid[i][j] == null;
        }
        if (grid[i][j] != expectedValue) {
          return false;
        }
        expectedValue++;
      }
    }
    return true;
  }

  Position _getCorrectPosition(int number) {
    final row = (number - 1) ~/ gridSize;
    final col = (number - 1) % gridSize;
    return Position(row, col);
  }

  void getHint() {
    if (hintsRemaining <= 0) return;

    for (int number = 1; number <= (gridSize * gridSize - 1); number++) {
      final correctPos = _getCorrectPosition(number);
      bool found = false;

      for (int i = 0; i < gridSize && !found; i++) {
        for (int j = 0; j < gridSize; j++) {
          if (grid[i][j] == number) {
            if (i != correctPos.row || j != correctPos.col) {
              if (_isValidMove(i, j)) {
                hintTile = number;
                hintsRemaining--;
                notifyListeners();

                Future.delayed(const Duration(seconds: 2), () {
                  hintTile = null;
                  notifyListeners();
                });
                return;
              }
            }
            found = true;
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.stop();
    super.dispose();
  }
}
