import "dart:math";

import 'package:color/color.dart';

class CanvasColor extends Color {
  CanvasColor.rgb(r, g, b) : super.rgb(r, g, b);
  
  String canvas() {
    return 'rgb(' + r.toString() + ',' + g.toString() + ',' + b.toString() + ')';
  }
}

CanvasColor RandomGrey(Random rng, num range) {
  num grey = 128 + rng.nextInt(range.toInt()) - range.toInt() ~/ 2;
  return new CanvasColor.rgb(grey, grey, grey + 10);
  
}