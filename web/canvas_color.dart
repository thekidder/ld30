library canvas_color;

import 'package:color/color.dart';

class CanvasColor extends Color {
  double a;
  CanvasColor.rgb(r, g, b, [this.a = 1.0]) : super.rgb(r, g, b);
  CanvasColor.grey(int grey) : this.rgb(grey, grey, grey + 10);
  
  String canvas() {
    return 'rgb(' + r.toString() + ',' + g.toString() + ',' + b.toString() + ')';
  }
}
