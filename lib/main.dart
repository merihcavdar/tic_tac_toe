import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tile_state.dart';
import 'board_tile.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  // ignore: unused_field
  final navigatorKey = GlobalKey<NavigatorState>();
  List<TileState> _boardState = List.filled(9, TileState.EMPTY);

  TileState _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
          child: Stack(children: [
            Image.asset('assets/images/board.png'),
            _boardTiles(),
          ]),
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(
      builder: (context) {
        final boardDimension = MediaQuery.of(context).size.width;
        final tileDimension = boardDimension / 3;

        return SizedBox(
          width: boardDimension,
          height: boardDimension,
          child: Column(
            children: chunk(_boardState, 3).asMap().entries.map(
              (entry) {
                final chunkIndex = entry.key;
                final tileStateChunk = entry.value;

                return Row(
                  children: tileStateChunk.asMap().entries.map(
                    (innerEntry) {
                      final innerIndex = innerEntry.key;
                      final tileState = innerEntry.value;
                      final tileIndex = (chunkIndex * 3) + innerIndex;

                      return BoardTile(
                          dimension: tileDimension,
                          onPressed: () => _updateTileStateForIndex(tileIndex),
                          tileState: tileState);
                    },
                  ).toList(),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(
        () {
          _boardState[selectedIndex] = _currentTurn;
          _currentTurn = _currentTurn == TileState.CROSS
              ? TileState.CIRCLE
              : TileState.CROSS;
        },
      );
      final winner = _findWinner();
      if (winner != null) {
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner() {
    // ignore: prefer_function_declarations_over_variables
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (var i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Winner'),
            content: Image.asset(tileState == TileState.CROSS
                ? 'assets/images/x.png'
                : 'assets/images/o.png'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _resetGame();
                  Navigator.pop(navigatorKey.currentState!.overlay!.context);
                },
                child: const Text('New Game'),
              ),
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
