import 'data_structure.dart';

int paddingSize = 3;
int blockViewRow = 20;
int blockViewCol = 10;
int blockRow = blockViewRow+paddingSize*2;
int blockCol = blockViewCol+paddingSize*2;


bool gamePause = false;
bool gameOver = false;

// List<ActiveBlock> activeBlocks = List.generate(
//   blockViewRow * blockViewCol,
//   (index) => ActiveBlock()
// );


List<StaticBlock> staticBlocks = List.generate(
  blockViewRow * blockViewCol,
  (index) => StaticBlock()
);
