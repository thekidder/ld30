import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:noise_algorithms/noise_algorithms.dart';

import 'color.dart';
import 'noise_world.dart';

class Game {
  CanvasElement canvas;
  HtmlElement fpsDisplay;
  Random rng;
  Perlin2 noise_range;
  Perlin2 noise_frequency;

  // fps counter
  num frames;
  num lastFps;

  NoiseWorld noise_world;
  static const noise_generation_period = const Duration(milliseconds: 33);
  Timer noise_generation_timer;

  Game(String selector, fps) {
    canvas = querySelector(selector) as CanvasElement;
    fpsDisplay = querySelector(fps);

    fpsDisplay.innerHtml = "0";
    frames = 0;
    lastFps = 0;

    rng = new Random();
    noise_range = new Perlin2(rng.nextInt((1 << 32) - 1));

    noise_world = new NoiseWorld(48, 48);
    generateNoise();

    requestRedraw();
  }

  void generateNoise() {
    int time = new DateTime.now().millisecondsSinceEpoch;

    num range = (noise_range.noise(0.0, time / 8000.0) + 1) / 2;
    range = range * 96 + 1;
    noise_world.generate(range.toInt());
    
    num frequency = (noise_range.noise(5.0, time / 16000.0) + 1) / 2;
    frequency *= 140 + 30;
    
    noise_generation_timer = new Timer(new Duration(milliseconds:1) * frequency, generateNoise);
  }

  void draw(num _) {
    int time = new DateTime.now().millisecondsSinceEpoch;
    var context = canvas.context2D;

    context.canvas.width = window.innerWidth;
    context.canvas.height = window.innerHeight;

    int numPixelsX = noise_world.width;
    int pixelSize = context.canvas.width ~/ numPixelsX;
    int numPixelsY = noise_world.height;

    int startX = (context.canvas.width - (pixelSize * numPixelsX)) ~/ 2;
    int startY = (context.canvas.height - (pixelSize * numPixelsY)) ~/ 2;

    for (num i = 0; i < numPixelsX; ++i) {
      for (num j = 0; j < numPixelsY; ++j) {
        CanvasColor c = new CanvasColor.grey(128 + noise_world.world[noise_world.width * j + i]);

        context
            ..lineWidth = 0
            ..fillStyle = c.canvas();

        context
            ..beginPath()
            ..rect(startX + i * pixelSize, startY + j * pixelSize, pixelSize, pixelSize)
            ..fill()
            ..closePath();


      }
    }

    calculateFps(time);

    requestRedraw();
  }

  void calculateFps(int time) {
    final num PERIOD = 1000;
    ++frames;

    if (time - lastFps > PERIOD) {
      fpsDisplay.innerHtml = (frames / (time - lastFps) * 1000).round().toString();

      frames = 0;
      lastFps = time;
    }
  }

  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }

}

void main() {
  Game game = new Game("#container", "#fps");
}
