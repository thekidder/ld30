library noise_world;

import "dart:math";

class NoiseWorld {
  int width, height;
  
  List<int> world;
  
  Random _rng;
  
  NoiseWorld(this.width, this.height) {
    world = new List<int>(width * height);
    
    _rng = new Random();
  }
  
  void generate(int range) {
    for(int i = 0; i < width; ++i) {
      for(int j = 0; j < height; ++j) {
        world[i + j * width] = _rng.nextInt(range) - range ~/ 2;
      }
    }
  }
  
}