import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:noise_algorithms/noise_algorithms.dart';

import 'color.dart';
import 'input.dart';
import 'noise_world.dart';
import 'protagonist.dart';
import 'utility.dart';

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
  static const Duration game_logic_period = const Duration(milliseconds: 20);
  Timer noise_generation_timer;
  Timer logic_timer;
  
  Input input;
  int lastMoveMs;
  
  Protagonist player;
  static final CanvasColor player_color = new CanvasColor.rgb(36, 138, 235);

  Game(String selector, fps) {
    canvas = querySelector(selector) as CanvasElement;
    fpsDisplay = querySelector(fps);

    fpsDisplay.innerHtml = "0";
    frames = 0;
    lastFps = 0;

    rng = new Random();
    noise_range = new Perlin2(rng.nextInt((1 << 32) - 1));

    input = new Input();
    lastMoveMs = 0;
    
    noise_world = new NoiseWorld(64, 32);
    player = new Protagonist(noise_world.width ~/ 2, noise_world.height ~/ 2);
    
    generateNoise();
    logic_timer = new Timer.periodic(game_logic_period, gameLoop);

    requestRedraw();
  }

  void generateNoise() {
    int time = new DateTime.now().millisecondsSinceEpoch;

    num range = (noise_range.noise(0.0, time / 8000.0) + 1) / 2;
    range = range * 127 + 1;
    noise_world.generate(range.toInt());
    
    num frequency = (noise_range.noise(5.0, time / 16000.0) + 1) / 2;
    frequency *= 140 + 30;
    
    noise_generation_timer = new Timer(new Duration(milliseconds:1) * frequency, generateNoise);
  }

  void gameLoop(Timer timer) {
    int time = new DateTime.now().millisecondsSinceEpoch;
    
    if(time - lastMoveMs > 20) {
      lastMoveMs = time;
      player.pos.x += input.leftright;
      player.pos.y += input.updown;
    }
    
    if(player.pos.x < 0) player.pos.x = 0;
    if(player.pos.y < 0) player.pos.y = 0;
    if(player.pos.x >= noise_world.width) player.pos.x = noise_world.width - 1;
    if(player.pos.y >= noise_world.height) player.pos.y = noise_world.height - 1; 
  }
  
  void draw(num _) {
    int time = new DateTime.now().millisecondsSinceEpoch;
    var context = canvas.context2D;

    context.canvas.width = window.innerWidth;
    context.canvas.height = window.innerHeight;

    int num_pixels_x = noise_world.width;
    int num_pixels_y = noise_world.height;
    int pixel_size = context.canvas.width ~/ num_pixels_x;
    if(context.canvas.height ~/ num_pixels_y < pixel_size) {
      pixel_size = context.canvas.height ~/ num_pixels_y;
    }

    int start_x = (context.canvas.width - (pixel_size * num_pixels_x)) ~/ 2;
    int start_y = (context.canvas.height - (pixel_size * num_pixels_y)) ~/ 2;

    CanvasColor white = new CanvasColor.rgb(220, 220, 230);
    for (num i = 0; i < num_pixels_x; ++i) {
      for (num j = 0; j < num_pixels_y; ++j) {
        drawSquare(
            context,
            start_x + i * pixel_size, start_y + j * pixel_size,
            pixel_size, white);

      }
    }
    
    for (num i = 0; i < num_pixels_x; ++i) {
      for (num j = 0; j < num_pixels_y; ++j) {
        if(i == player.pos.x && j == player.pos.y) {
          drawSquare(
              context,
              start_x + i * pixel_size,
              start_y + j * pixel_size,
              pixel_size, player_color);
        } else {
          CanvasColor c = new CanvasColor.grey(128 + noise_world.world[noise_world.width * j + i]);
          c.a = (clamp(dist_sq(player.pos, new GridPoint(i, j)), 0, 100)) / 100;
          drawSquare(
              context, start_x + i * pixel_size, start_y + j * pixel_size, pixel_size, c);
        }
      }
    }

    calculateFps(time);

    requestRedraw();
  }
  
  void drawSquare(var context, int x, int y, int s, CanvasColor color) {
    context
        ..globalAlpha = color.a
        ..lineWidth = 0
        ..fillStyle = color.canvas();

    context
        ..beginPath()
        ..rect(x, y, s, s)
        ..fill()
        ..closePath();
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
