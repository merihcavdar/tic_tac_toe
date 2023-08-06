import 'package:flutter/material.dart';
import 'tile_state.dart';

class BoardTile extends StatelessWidget {
  const BoardTile(
      {super.key,
      required this.dimension,
      required this.onPressed,
      required this.tileState});

  final double dimension;
  final VoidCallback onPressed;
  final TileState tileState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimension,
      width: dimension,
      child: InkWell(
        onTap: onPressed,
        child: _widgetForTileState(),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset('assets/images/x.png');
        }
        break;

      case TileState.CIRCLE:
        {
          widget = Image.asset('assets/images/o.png');
        }
        break;
    }
    return widget;
  }
}
