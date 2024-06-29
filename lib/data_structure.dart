class ActiveBlock {
  // 0:空砖块，1:活动砖块
  int status=0;
  // patterns:
  // 0:none
  // 1:[][] 2:[]     3:  []   4:    [] 5:  [][] 6:[][]   7:[][][][]
  //   [][]   [][][]   [][][]   [][][]   [][]       [][]
  bool isMatrix=false;
  ActiveBlock({this.status = 0, this.isMatrix = false});

  ActiveBlock copy() {
    return ActiveBlock(
      status: this.status,
      isMatrix: this.isMatrix,
    );
  }
}

class StaticBlock {
  // 0:空砖块，1:死砖块，2:墙砖块
  int status=0;
  StaticBlock({this.status = 0});
}
