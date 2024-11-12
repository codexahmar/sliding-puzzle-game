// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Grid size
//   static const int gridSize = 3;
//   late List<List<int?>> grid;
//   late Position emptyPosition;
//   int moves = 0;
//   late Stopwatch stopwatch;
//   late Timer timer;
//   String timeElapsed = '00:00';
//   int? hintTile;
//   int hintsRemaining = 3;

//   @override
//   void initState() {
//     super.initState();
//     stopwatch = Stopwatch();
//     timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
//     _initializeGame();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     stopwatch.stop();
//     super.dispose();
//   }

//   void _updateTime(Timer timer) {
//     if (stopwatch.isRunning) {
//       setState(() {
//         final minutes = stopwatch.elapsed.inMinutes;
//         final seconds = stopwatch.elapsed.inSeconds % 60;
//         timeElapsed =
//             '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//       });
//     }
//   }

//   void _initializeGame() {
//     // Reset game state
//     moves = 0;
//     stopwatch.reset();
//     stopwatch.start();
//     hintsRemaining = 3;
//     hintTile = null;

//     // Create solved grid first
//     grid = List.generate(
//       gridSize,
//       (i) => List.generate(
//         gridSize,
//         (j) => i * gridSize + j + 1,
//       ),
//     );
//     grid[gridSize - 1][gridSize - 1] = null;
//     emptyPosition = Position(gridSize - 1, gridSize - 1);

//     // Shuffle without counting moves
//     _shufflePuzzle();
//   }

//   void _shufflePuzzle() {
//     final random = Random();
//     // Fix the type casting issue with proper List generation
//     List<List<int?>> tempGrid = List.generate(
//       gridSize,
//       (i) => List.generate(
//         gridSize,
//         (j) => grid[i][j],
//       ),
//     );
//     Position tempEmpty = Position(emptyPosition.row, emptyPosition.col);

//     for (int i = 0; i < 100; i++) {
//       final validMoves = _getValidMovesForPosition(tempEmpty);
//       final move = validMoves[random.nextInt(validMoves.length)];

//       // Perform move on temporary grid
//       final temp = tempGrid[tempEmpty.row][tempEmpty.col];
//       tempGrid[tempEmpty.row][tempEmpty.col] = tempGrid[move.row][move.col];
//       tempGrid[move.row][move.col] = temp;
//       tempEmpty = move;
//     }

//     // Update actual grid after shuffling
//     setState(() {
//       grid = tempGrid;
//       emptyPosition = tempEmpty;
//     });
//   }

//   List<Position> _getValidMovesForPosition(Position pos) {
//     final List<Position> validMoves = [];
//     final directions = [
//       [-1, 0],
//       [1, 0],
//       [0, -1],
//       [0, 1]
//     ];

//     for (final direction in directions) {
//       final newRow = pos.row + direction[0];
//       final newCol = pos.col + direction[1];

//       if (newRow >= 0 &&
//           newRow < gridSize &&
//           newCol >= 0 &&
//           newCol < gridSize) {
//         validMoves.add(Position(newRow, newCol));
//       }
//     }
//     return validMoves;
//   }

//   void _moveTile(int row, int col) {
//     if (_isValidMove(row, col)) {
//       setState(() {
//         grid[emptyPosition.row][emptyPosition.col] = grid[row][col];
//         grid[row][col] = null;
//         emptyPosition = Position(row, col);
//         moves++;

//         if (_checkWin()) {
//           stopwatch.stop();
//           _showWinDialog();
//         }
//       });
//     }
//   }

//   bool _isValidMove(int row, int col) {
//     return (row == emptyPosition.row && (col - emptyPosition.col).abs() == 1) ||
//         (col == emptyPosition.col && (row - emptyPosition.row).abs() == 1);
//   }

//   bool _checkWin() {
//     int expectedValue = 1;
//     for (int i = 0; i < gridSize; i++) {
//       for (int j = 0; j < gridSize; j++) {
//         if (i == gridSize - 1 && j == gridSize - 1) {
//           return grid[i][j] == null;
//         }
//         if (grid[i][j] != expectedValue) {
//           return false;
//         }
//         expectedValue++;
//       }
//     }
//     return true;
//   }

//   void _showWinDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Congratulations! 🎉'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('You solved the puzzle in:'),
//             const SizedBox(height: 8),
//             Text('Moves: $moves',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Text('Time: $timeElapsed',
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               setState(() => _initializeGame());
//             },
//             child: const Text('Play Again'),
//           ),
//         ],
//       ),
//     );
//   }

//   Position _getCorrectPosition(int number) {
//     final row = (number - 1) ~/ gridSize;
//     final col = (number - 1) % gridSize;
//     return Position(row, col);
//   }

//   void _getHint() {
//     if (hintsRemaining <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No hints remaining!'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     // Find the first misplaced number that can be moved
//     for (int number = 1; number <= 8; number++) {
//       final correctPos = _getCorrectPosition(number);
//       bool found = false;

//       // Find where this number currently is
//       for (int i = 0; i < gridSize && !found; i++) {
//         for (int j = 0; j < gridSize; j++) {
//           if (grid[i][j] == number) {
//             // If the number is not in its correct position and can be moved
//             if (i != correctPos.row || j != correctPos.col) {
//               if (_isValidMove(i, j)) {
//                 setState(() {
//                   hintTile = number;
//                   hintsRemaining--;
//                 });
//                 // Clear hint after 2 seconds
//                 Future.delayed(const Duration(seconds: 2), () {
//                   if (mounted) {
//                     setState(() => hintTile = null);
//                   }
//                 });
//                 return;
//               }
//             }
//             found = true;
//             break;
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'Sliding Puzzle',
//           style: TextStyle(
//             color: Colors.blue[800],
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.blue[800]),
//             onPressed: () => setState(() => _initializeGame()),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 500),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Game Stats Card
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 24),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16,
//                     horizontal: 24,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildStatItem(
//                           'Moves', moves.toString(), Icons.touch_app),
//                       _buildStatItem('Time', timeElapsed, Icons.timer),
//                       _buildHintSection(),
//                     ],
//                   ),
//                 ),

//                 // Puzzle Grid
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: AspectRatio(
//                       aspectRatio: 1,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: GridView.builder(
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: gridSize,
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                           itemCount: gridSize * gridSize,
//                           itemBuilder: (context, index) {
//                             final row = index ~/ gridSize;
//                             final col = index % gridSize;
//                             return _buildTile(row, col, grid[row][col]);
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value, IconData icon) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: Colors.blue[800], size: 24),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: Colors.blue[800],
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHintSection() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.lightbulb_outline, color: Colors.blue[800], size: 24),
//         const SizedBox(height: 8),
//         const Text(
//           'Hints',
//           style: TextStyle(
//             color: Colors.grey,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               hintsRemaining.toString(),
//               style: TextStyle(
//                 color: Colors.blue[800],
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.help_outline, size: 20),
//               color: Colors.blue[800],
//               onPressed: hintsRemaining > 0 ? _getHint : null,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTile(int row, int col, int? number) {
//     if (number == null) {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(12),
//         ),
//       );
//     }

//     final isHinted = number == hintTile;
//     return Material(
//       elevation: isHinted ? 8 : 4,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _moveTile(row, col),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: isHinted
//                   ? [Colors.green[400]!, Colors.green[600]!]
//                   : [Colors.blue[400]!, Colors.blue[700]!],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: isHinted
//                 ? [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.3),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     )
//                   ]
//                 : null,
//           ),
//           child: Center(
//             child: Text(
//               number.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withOpacity(0.3),
//                     offset: const Offset(1, 1),
//                     blurRadius: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Position {
//   final int row;
//   final int col;

//   Position(this.row, this.col);
// }
