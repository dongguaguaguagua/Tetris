import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'data_structure.dart';
import 'global_var.dart';
import 'block_view.dart';
import 'active_actions.dart';
import 'static_actions.dart';
import 'utilities.dart';
import 'dart:async';
import 'score_system.dart';

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<ActiveBlock> activeBlocks =
      List.generate(blockRow * blockCol, (index) => ActiveBlock());
  List<StaticBlock> staticBlocks =
      List.generate(blockRow * blockCol, (index) => StaticBlock());
  List<ActiveBlock> tempActiveBlocks = [];

  // to receive the keyboard event,
  // the main game view should have a focus.
  // Or `space` `enter` key will not take effect.
  final FocusNode _focusNode = FocusNode();
  // the game timer is set to control the whole game.
  // like starting, pausing the game and controlling the speed.
  Timer? _gameTimer;
  // the move timer is set to dealing with keyboard events.
  Timer? _moveTimer;

  void initState() {
    super.initState();
    int firstPattern = randomPatternGenerator();
    initActiveBlocks(activeBlocks, firstPattern);
    nextPattern = randomPatternGenerator();
    initStaticBlocks(staticBlocks);
    startGameTimer();
  }

  void startGameTimer() {
    final Duration duration = Duration(milliseconds: 500);

    _gameTimer = Timer.periodic(duration, (timer) {
      if (mounted) {
        setState(() {
          descend();
        });
      }
    });
  }

  // Long press some keys will invoke this function,
  // and it will set a timer to circulate the execution.
  void startMoveTimer(VoidCallback callback) {
    _moveTimer?.cancel();
    callback();
    _moveTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      callback();
    });
  }

  void toggleGamePause() {
    if (gamePause == false) {
      _gameTimer?.cancel();
      gamePause = true;
    } else {
      startGameTimer();
      gamePause = false;
    }
  }

  void restartGame() {
    setState(() {
      gameOver = false;
    });
    int firstPattern = randomPatternGenerator();
    initActiveBlocks(activeBlocks, firstPattern);
    nextPattern = randomPatternGenerator();
    initStaticBlocks(staticBlocks);
    startGameTimer();
  }

  void rotate() {
    // make a deeper copy of the `activeBlocks` list.
    List<ActiveBlock> tempActiveBlocks =
        activeBlocks.map((block) => block.copy()).toList();
    rotationHandler(activeBlocks);
    setState(() {
      wallCollisionHandler(activeBlocks, staticBlocks, tempActiveBlocks);
    });
    List<int> lines = lineDetector(staticBlocks);
    lineEliminater(staticBlocks, lines);
  }

  void descend() {
    tempActiveBlocks = List.from(activeBlocks);
    descendHandler(activeBlocks);
    setState(() {
      deadCollisionHandler(activeBlocks, staticBlocks, tempActiveBlocks);
      List<int> lines = lineDetector(staticBlocks);
      lineEliminater(staticBlocks, lines);
      addScore(lines);
    });
    gameOverDetector(staticBlocks, _gameTimer);
  }

  void dropDown() {
    // The following solution is too slow.
    // TODO: give a better algorithm
    for (int i = 0; i < blockRow; i++) {
      tempActiveBlocks = List.from(activeBlocks);
      descendHandler(tempActiveBlocks);
      int status = collisionDetector(tempActiveBlocks, staticBlocks);
      if (status == 0) {
        activeBlocks = tempActiveBlocks;
      } else {
        break;
      }
    }
  }

  void ascend() {
    tempActiveBlocks = List.from(activeBlocks);
    ascendHandler(activeBlocks);
    setState(() {
      wallCollisionHandler(activeBlocks, staticBlocks, tempActiveBlocks);
    });
    List<int> lines = lineDetector(staticBlocks);
    lineEliminater(staticBlocks, lines);
  }

  void moveRight() {
    tempActiveBlocks = List.from(activeBlocks);
    rightMoveHandler(activeBlocks);
    setState(() {
      wallCollisionHandler(activeBlocks, staticBlocks, tempActiveBlocks);
    });
    List<int> lines = lineDetector(staticBlocks);
    lineEliminater(staticBlocks, lines);
  }

  void moveLeft() {
    tempActiveBlocks = List.from(activeBlocks);
    leftMoveHandler(activeBlocks);
    setState(() {
      wallCollisionHandler(activeBlocks, staticBlocks, tempActiveBlocks);
    });
    List<int> lines = lineDetector(staticBlocks);
    lineEliminater(staticBlocks, lines);
  }

  // We use timer to handle long press event,
  // when key is pressed, it will execute function circulatly until key up.
  void keyPressHandler(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          startMoveTimer(rotate);
          break;
        case LogicalKeyboardKey.arrowDown:
          startMoveTimer(descend);
          break;
        case LogicalKeyboardKey.arrowRight:
          startMoveTimer(moveRight);
          break;
        case LogicalKeyboardKey.arrowLeft:
          startMoveTimer(moveLeft);
          break;
        case LogicalKeyboardKey.enter:
          dropDown();
          break;
        case LogicalKeyboardKey.space:
          toggleGamePause();
          break;
        default:
      }
    } else if (event is KeyUpEvent) {
      _moveTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: gameOver ? gameOverView() : keyBoardListener(gameView()));
  }

  Widget gameView() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Expanded(
                child: BlockView(
                    activeblocks: activeBlocks, staticBlocks: staticBlocks)),
            Row(children: [
              Expanded(child: controllButton(ascend, Icons.arrow_upward)),
              Expanded(child: controllButton(descend, Icons.arrow_downward)),
              Expanded(child: controllButton(rotate, Icons.rotate_right)),
              Expanded(child: controllButton(moveLeft, Icons.arrow_back)),
              Expanded(child: controllButton(moveRight, Icons.arrow_forward)),
            ]),
          ],
        )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: nextPatternView()),
            Expanded(child: scoreView()),
            Expanded(child: lineView()),
          ],
        ))
      ],
    );
  }

  Widget gameOverView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
          child: Column(
        children: [
          const Text("Game Over!"),
          IconButton(
              onPressed: restartGame,
              icon: const Icon(Icons.rotate_90_degrees_cw_sharp))
        ],
      )),
    );
  }

  Widget controllButton(VoidCallback action, IconData icon) {
    return GestureDetector(
      onLongPressStart: (_) {
        startMoveTimer(action);
      },
      onLongPressEnd: (_) {
        _moveTimer?.cancel();
      },
      child: IconButton(
        onPressed: action,
        icon: Icon(icon),
      ),
    );
  }

  Widget keyBoardListener(Widget w) {
    return KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: keyPressHandler,
        child: w);
  }

  Widget scoreView() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Score", style: TextStyle(fontSize: 20)),
            Text(
              score.toString(),
              style: TextStyle(fontSize: 30),
            )
          ],
        ));
  }

  Widget lineView() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Eliminated Lines",
              style: TextStyle(fontSize: 20),
            ),
            Text(eliminatedLines.toString(), style: TextStyle(fontSize: 30))
          ],
        ));
  }

  Widget nextPatternView() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Next Pattern",
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: PatternIndicator()),
            ]));
  }
}
