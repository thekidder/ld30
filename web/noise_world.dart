library noise_world;

import "dart:math";

import 'canvas_color.dart';
import 'protagonist.dart';
import 'renderer.dart';
import' utility.dart';

class NoiseValue {
  int noise;
  Pixel rendered;
}

class NoiseWorld {
  int width, height;
  
  List<NoiseValue> world;
  
  Random _rng;
  Protagonist _player;
  
  NoiseWorld(Renderer renderer, this.width, this.height, Protagonist this._player) {
    world = new List<NoiseValue>(width * height);
    
    for(int i = 0; i < width; ++i) {
      for(int j = 0; j < height; ++j) {
        NoiseValue val = new NoiseValue();
        val.rendered = new Pixel(new Point<int>(i, j), 100, new CanvasColor.rgb(0, 0, 0), true);
        renderer.addPixel(val.rendered);
        world[i + j * width] = val;
      }
    }
    
    _rng = new Random();
  }
  
  void generate(int range) {
    for(int i = 0; i < width; ++i) {
      for(int j = 0; j < height; ++j) {
        NoiseValue val = world[i + j * width];
        val.noise = _rng.nextInt(range) - range ~/ 2;
        CanvasColor color = new CanvasColor.grey(128 + val.noise);
        color.a = (clamp(_player.pos.squaredDistanceTo(new Point<int>(i, j)), 0, 100)) / 100;
        val.rendered.color = color;
      }
    }
  }
  
  void movePlayer() {
    for(int i = 0; i < width; ++i) {
      for(int j = 0; j < height; ++j) {
        NoiseValue val = world[i + j * width];
        CanvasColor color = new CanvasColor.grey(128 + val.noise);
        color.a = (clamp(_player.pos.squaredDistanceTo(new Point<int>(i, j)), 0, 100)) / 100;
        val.rendered.color = color;
      }
    }
  }
  
}