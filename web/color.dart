library color;

import 'package:color/color.dart';

class CanvasColor extends Color {
  CanvasColor.rgb(r, g, b) : super.rgb(r, g, b);
  CanvasColor.grey(int grey) : this.rgb(grey, grey, grey + 10);
  
  String canvas() {
    return 'rgb(' + r.toString() + ',' + g.toString() + ',' + b.toString() + ')';
  }
}
