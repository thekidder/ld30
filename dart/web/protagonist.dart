library protagonist;

import 'dart:math';

import 'canvas_color.dart';
import 'renderer.dart';

class Protagonist {
  static final CanvasColor PLAYER_COLOR = new CanvasColor.rgb(36, 138, 235);

  Point<int> _pos;
  Pixel _rendered;
  
  Protagonist(Renderer renderer, Point<int> this._pos) {
    _rendered = new Pixel(_pos, 50, PLAYER_COLOR);
    renderer.addPixel(_rendered);
  }
  
  void set pos(Point<int> p) {
    _pos = p;
    _rendered.pos = p;
  }
  
  Point<int> get pos => _pos;
}