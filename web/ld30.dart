import 'dart:html';

class Game {
  CanvasElement canvas;
  
  Game(String selector) {
    canvas = querySelector(selector) as CanvasElement;
    
    requestRedraw();
  }
  
  void draw(num _) {
    var context = canvas.context2D;
    
    context.canvas.width  = window.innerWidth;
    context.canvas.height = window.innerHeight;
    
    context..lineWidth = 0
           ..fillStyle = 'black';
    
    context..beginPath()
           ..rect(0, 0, 32, 32)
           ..fill()
           ..closePath();
    
    context..beginPath()
           ..rect(context.canvas.width - 32, context.canvas.height - 32, 32, 32)
           ..fill()
           ..closePath();
    
    requestRedraw();
  }
  
  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }

}

void main() {
  Game game = new Game("#container");
}