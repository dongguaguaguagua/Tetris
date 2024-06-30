import 'dart:math';

import 'global_var.dart';
import 'data_structure.dart';

// generate a matrix for a certain pattern,
// making it easier to rotate.
void matrixGenerator(List<ActiveBlock> blocks, int pattern) {
  int startPoint = (blockCol ~/ 2.0).toInt();
  switch (pattern) {
    // block pattern: 2*2 matrix
    case 1:
      for (int i = 0; i < 2 * blockCol; i++) {
        int col = i % blockCol;
        int row = i ~/ blockRow;
        if ((col - startPoint + 0.5).abs() <= 1 && row <= 1 && row >= 0) {
          blocks[i].isMatrix = true;
        }
      }
      break;
    // tetris pattern: 4*4 matrix
    case 7:
      for (int i = 0; i < 4 * blockCol; i++) {
        int col = i % blockCol;
        int row = i ~/ blockRow;
        if ((col - startPoint + 0.5).abs() <= 2 && row <= 3 && row >= 0) {
          blocks[i].isMatrix = true;
        }
      }
    // other patterns: 3*3 matrix
    default:
      for (int i = 0; i < 3 * blockCol; i++) {
        int col = i % blockCol;
        int row = i ~/ blockRow;
        if ((col - startPoint).abs() <= 1 && row <= 2 && row >= 0) {
          blocks[i].isMatrix = true;
        }
      }
  }
}

void patternGenerator(List<ActiveBlock> blocks, int pattern, int col) {
  int startPoint = (col ~/ 2).toInt();
  switch (pattern) {
    case 1:
      //[ ][*]
      //[ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      break;
    case 2:
      //[ ] *
      //[ ][ ][ ]
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      blocks[startPoint + col + 1].status = 1;
      break;
    case 3:
      //   [*]
      //[ ][ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      blocks[startPoint + col + 1].status = 1;
      break;
    case 4:
      //    * [ ]
      //[ ][ ][ ]
      blocks[startPoint + 1].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      blocks[startPoint + col + 1].status = 1;
      break;
    case 5:
      //   [*][ ]
      //[ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint + 1].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      break;
    case 6:
      //[ ][*]
      //   [ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col + 1].status = 1;
      break;
    case 7:
      //[ ][ ][*][ ]
      blocks[startPoint + col].status = 1;
      blocks[startPoint + col - 1].status = 1;
      blocks[startPoint + col - 2].status = 1;
      blocks[startPoint + col + 1].status = 1;
      break;
    default:
      break;
  }
}

// rotate the matrix 90 degree:
// step 1:transpose the matrix.
// step 2:reverse every row of the matrix.
void rotationHandler(List<ActiveBlock> blocks) {
  List<int> indexMatrix = [];
  List<int> statusMatrix = [];
  for (int i = 0; i < blocks.length; i++) {
    if (blocks[i].isMatrix == true) {
      indexMatrix.add(i);
      statusMatrix.add(blocks[i].status);
    }
  }
  // shift the order of `transpose` and `reverse`
  // to change the rotate direction.
  if(isClockwise){
    statusMatrix = transpose(statusMatrix);
    reverseRows(statusMatrix);
  }else{
    reverseRows(statusMatrix);
    statusMatrix = transpose(statusMatrix);
  }

  for (int j = 0; j < statusMatrix.length; j++) {
    int index = indexMatrix[j];
    blocks[index].status = statusMatrix[j];
  }
}

// transpose a matrix
List<int> transpose(List<int> matrix) {
  // calculate the size of matrix
  int length = sqrt(matrix.length).toInt();

  List<int> transposedMatrix = List<int>.filled(matrix.length, 0);

  for (int i = 0; i < length; i++) {
    for (int j = 0; j < length; j++) {
      transposedMatrix[j * length + i] = matrix[i * length + j];
    }
  }
  return transposedMatrix;
}

// reverse every row of a matrix
void reverseRows(List<int> matrix) {
  int length = sqrt(matrix.length).toInt();
  for (int i = 0; i < length; i++) {
    int start = i * length;
    int end = start + length - 1;
    while (start < end) {
      int temp = matrix[start];
      matrix[start] = matrix[end];
      matrix[end] = temp;
      start++;
      end--;
    }
  }
}

void descendHandler(List<ActiveBlock> blocks) {
  for (int i = blocks.length - 1; i >= 0; i--) {
    if (blocks[i].isMatrix == true) {
      // when object is on the bottom,
      // The process should stop.
      if (i ~/ blockCol == blockRow - 1) {
        print("The object has reached to the bottom of List.");
        break;
      }
      blocks[i + blockCol] = blocks[i];
      blocks[i] = ActiveBlock();
    }
  }
}

void ascendHandler(List<ActiveBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    if (blocks[i].isMatrix == true) {
      if (i ~/ blockCol == 0) {
        print("The object has reached to the top of List.");
        break;
      }
      blocks[i - blockCol] = blocks[i];
      blocks[i] = ActiveBlock();
    }
  }
}

void rightMoveHandler(List<ActiveBlock> blocks) {
  for (int i = blocks.length - 1; i >= 0; i--) {
    if (blocks[i].isMatrix == true) {
      if (i % blockCol == blockCol - 1) {
        print("The object has reached to the right side of List.");
        break;
      }
      blocks[i + 1] = blocks[i];
      blocks[i] = ActiveBlock();
    }
  }
}

void leftMoveHandler(List<ActiveBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    if (blocks[i].isMatrix == true) {
      if (i % blockCol == 0) {
        print("The object has reached to the left side of List.");
        break;
      }
      blocks[i - 1] = blocks[i];
      blocks[i] = ActiveBlock();
    }
  }
}

int randomPatternGenerator() {
  Random random = Random();
  int pattern = random.nextInt(7) + 1;
  return pattern;
}

List<ActiveBlock> generateIndicator(int pattern) {
  List<ActiveBlock> blocks = List.generate(2 * 4, (index) => ActiveBlock());
  for (int i = 0; i < blocks.length; i++) {
    blocks[i] = ActiveBlock();
  }
  patternGenerator(blocks, pattern, 4);
  return blocks;
}

void initActiveBlocks(List<ActiveBlock> blocks, int pattern) {
  // initiate
  for (int i = 0; i < blocks.length; i++) {
    blocks[i] = ActiveBlock();
  }

  matrixGenerator(blocks, pattern);
  patternGenerator(blocks, pattern, blockCol);

  // randomly rotate this pattern.
  Random random = Random();
  int rotateNum = random.nextInt(4);
  for (int i = 0; i < rotateNum; i++) {
    rotationHandler(blocks);
  }
  // add score
  score+=20;
}
