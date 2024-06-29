import 'global_var.dart';
import 'data_structure.dart';
import 'active_actions.dart';
import 'package:collection/collection.dart';
import 'dart:async';

void displayActive(List<ActiveBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    if (blocks[i].status == 1) {
      print(i);
    }
  }
}

// by summing the numbers of each line,
// it can detect which line is full.
List<int> lineDetector(List<StaticBlock> blocks) {
  List<int> lines = [];
  for (int i = 0; i < blockRow - paddingSize; i++) {
    int lineSum = blocks
        .getRange(i * blockCol, (i + 1) * blockCol)
        .map((e) => e.status)
        .sum;
    if (lineSum == 2 * paddingSize * 2 + blockViewCol * 1) {
      lines.add(i);
    }
  }
  return lines;
}

// eliminate the whole line
void lineEliminater(List<StaticBlock> blocks,List<int> lines) {
  if (lines.isNotEmpty) {
    for (int i in lines) {
      for (int j = 0; j < blockCol; j++) {
        if (j < paddingSize || j >= blockCol - paddingSize) {
          blocks.insert(0, StaticBlock(status: 2));
        } else {
          blocks.insert(0, StaticBlock(status: 0));
        }
      }
      blocks.removeRange((i + 1) * blockCol, (i + 2) * blockCol);
    }
  }
}

// return code:
// 0:no collisions, 1:collision with dead, 2:collision with walls
int collisionDetector(
    List<ActiveBlock> activeBlocks, List<StaticBlock> staticBlocks) {
  for (int i = 0; i < activeBlocks.length; i++) {
    int status = activeBlocks[i].status * staticBlocks[i].status;
    if (status == 1) {
      print("collision with dead");
      return status;
    } else if (status == 2) {
      print("collision with walls");
      return status;
    }
  }
  print("no collisions");
  return 0;
}

void deadCollisionHandler(List<ActiveBlock> activeBlocks,
    List<StaticBlock> staticBlocks, List<ActiveBlock> tempBlocks) {
  int status = collisionDetector(activeBlocks, staticBlocks);
  if (status == 2 || status == 1) {
    for (int i = 0; i < tempBlocks.length; i++) {
      if (tempBlocks[i].status == 1) {
        staticBlocks[i].status = 1;
      }
    }
    initActiveBlocks(activeBlocks);
    print("collided");
  }
}

void wallCollisionHandler(List<ActiveBlock> activeBlocks,
    List<StaticBlock> staticBlocks, List<ActiveBlock> tempBlocks) {
  int status = collisionDetector(activeBlocks, staticBlocks);
  if (status == 2 || status == 1) {
    activeBlocks
      ..clear()
      ..addAll(tempBlocks);
  }
}

bool gameOverDetector(List<StaticBlock> staticBlocks, Timer? timer) {
  for (int i = paddingSize * blockCol; i < (paddingSize + 1) * blockCol; i++) {
    if (staticBlocks[i].status == 1) {
      print("Game Over");
      gameOver = true;
      timer?.cancel();
      return true;
    }
  }
  return false;
}
