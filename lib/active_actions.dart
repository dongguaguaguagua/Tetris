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

void patternGenerator(List<ActiveBlock> blocks, int pattern) {
  int startPoint = (blockCol ~/ 2).toInt();
  switch (pattern) {
    case 1:
      //[ ][*]
      //[ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      break;
    case 2:
      //[ ] *
      //[ ][ ][ ]
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      blocks[startPoint + blockCol + 1].status = 1;
      break;
    case 3:
      //   [*]
      //[ ][ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      blocks[startPoint + blockCol + 1].status = 1;
      break;
    case 4:
      //    * [ ]
      //[ ][ ][ ]
      blocks[startPoint + 1].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      blocks[startPoint + blockCol + 1].status = 1;
      break;
    case 5:
      //   [*][ ]
      //[ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint + 1].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      break;
    case 6:
      //[ ][*]
      //   [ ][ ]
      blocks[startPoint].status = 1;
      blocks[startPoint - 1].status = 1;
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol + 1].status = 1;
      break;
    case 7:
      //[ ][ ][*][ ]
      blocks[startPoint + blockCol].status = 1;
      blocks[startPoint + blockCol - 1].status = 1;
      blocks[startPoint + blockCol - 2].status = 1;
      blocks[startPoint + blockCol + 1].status = 1;
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
  statusMatrix = transpose(statusMatrix);
  reverseRows(statusMatrix);
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

void initActiveBlocks(List<ActiveBlock> blocks) {
  // initiate
  for(int i=0;i<blocks.length;i++){
    blocks[i]=ActiveBlock();
  }
  // randomly generate pattern number.
  Random random = Random();
  int pattern = random.nextInt(7)+1;
  // int pattern = 7;

  matrixGenerator(blocks, pattern);
  patternGenerator(blocks, pattern);

  // randomly rotate this pattern.
  int rotateNum = random.nextInt(4);
  for (int i = 0; i < rotateNum; i++) {
    rotationHandler(blocks);
  }
}