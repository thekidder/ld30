import 'dart:html';
import 'dart:math';

import 'package:noise_algorithms/noise_algorithms.dart';

import 'color.dart';

class Game {
  CanvasElement canvas;
  Random rng;
  Perlin2 perlin;
  
  Game(String selector) {
    canvas = querySelector(selector) as CanvasElement;
    
    rng = new Random();
    perlin = new Perlin2(rng.nextInt(765675865));
    
    requestRedraw();
  }
  
  void draw(num _) {
    num time = new DateTime.now().millisecondsSinceEpoch;

    var context = canvas.context2D;
    
    context.canvas.width  = window.innerWidth;
    context.canvas.height = window.innerHeight;
    
    num numPixelsX = 48;
    num pixelSize = context.canvas.width ~/ numPixelsX;
    num numPixelsY = context.canvas.height ~/ pixelSize;
    
    num startX = (context.canvas.width - (pixelSize * numPixelsX)) ~/ 2;
    num startY = (context.canvas.height - (pixelSize * numPixelsY)) ~/ 2;

    num range = (perlin.noise(0.0, time / 8000.0) + 1) / 2;
    range = range * 96 + 1;
    
    for(num i = 0; i < numPixelsX; ++i) {
      for(num j = 0; j < numPixelsY; ++j) {
        CanvasColor c = RandomGrey(rng, range);
        
        context..lineWidth = 0
               ..fillStyle = c.canvas();
        
        context..beginPath()
               ..rect(startX + i * pixelSize, startY + j * pixelSize,
                   pixelSize, pixelSize)
               ..fill()
               ..closePath();


      }
    }
    
    requestRedraw();
  }
  
  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }

}

void main() {
  Game game = new Game("#container");
}