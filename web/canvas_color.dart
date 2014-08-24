library canvas_color;

import 'package:color/color.dart';
import 'package:three/three.dart' as Three;

class CanvasColor extends Color {
  double a;
  CanvasColor.rgb(r, g, b, [this.a = 1.0]) : super.rgb(r, g, b);
  CanvasColor.grey(int grey) : this.rgb(grey, grey, grey + 10);
  
  String canvas() {
    return 'rgb(' + r.toString() + ',' + g.toString() + ',' + b.toString() + ')';
  }
  
  int hex() {
    return ((r & 0xFF) << 16) + ((g & 0xFF) << 8) + (b & 0xFF);
  }
  
  Three.Color threeColor() {
    return new Three.Color(hex());
  }
}
