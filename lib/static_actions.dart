import 'global_var.dart';
import 'data_structure.dart';

void wallGenerator(List<StaticBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    if (i % blockCol < paddingSize ||
        i % blockCol >= blockCol - paddingSize ||
        i ~/ blockCol >= blockRow - paddingSize) {
      blocks[i].status = 2;
    }
  }
}

void initStaticBlocks(List<StaticBlock> blocks) {
  // initiate
  for (int i = 0; i < blocks.length; i++) {
    blocks[i] = StaticBlock();
  }
  wallGenerator(blocks);
}
