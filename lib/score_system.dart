import 'global_var.dart';

void addScore(List<int> lines){
  switch (lines.length) {
    case 1:
      score+=100;
      break;
    case 2:
      score+=200;
    case 3:
      score+=500;
    case 4:
      score+=1000;
    default:
  }
  eliminatedLines += lines.length;
}
