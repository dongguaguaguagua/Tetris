import 'package:flutter/material.dart';
import 'data_structure.dart';
import 'global_var.dart';

class BlockView extends StatefulWidget {
  List<ActiveBlock> activeblocks;
  List<StaticBlock> staticBlocks;
  BlockView(
      {super.key, required this.activeblocks, required this.staticBlocks});

  @override
  State<BlockView> createState() => _BlockViewState();
}

class _BlockViewState extends State<BlockView> {
  Color backgroundColor = Colors.white;
  Color blockColor(ActiveBlock active, StaticBlock static) {
    if (active.status == 1) {
      return Colors.purple;
    } else if (static.status == 1) {
      return Colors.black;
    }
    return Colors.grey;
  }

  int calculateViewPos(int viewPos){
    int viewRow=viewPos ~/ blockViewCol;
    int viewCol=viewPos % blockViewCol;

    return (paddingSize + viewRow)*blockCol+viewCol+paddingSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: blockViewCol,
          ),
          itemCount: blockViewCol * blockViewRow,
          itemBuilder: (context, index) {
            int viewIndex=calculateViewPos(index);
            ActiveBlock activeBlock = widget.activeblocks[viewIndex];
            StaticBlock staticBlock = widget.staticBlocks[viewIndex];
            return block(activeBlock, staticBlock);
          },
        ),
      ),
    );
  }

  Widget block(ActiveBlock activeBlock, StaticBlock staticBlock) {
    return Container(
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: blockColor(activeBlock, staticBlock),
        border:
            Border.all(color: blockColor(activeBlock, staticBlock), width: 2),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: backgroundColor, width: 2)),
        ),
      ),
    );
  }
}
