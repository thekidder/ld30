library utility;

import 'dart:math';

class GridPoint {
  int x, y;
  
  GridPoint(int this.x, int this.y);
}

num clamp(num a, num min_val, num max_val) {
  return max(min(a, max_val), min_val);
}

num dist(GridPoint a, GridPoint b) {
  return sqrt(dist_sq(a, b));
}


num dist_sq(GridPoint a, GridPoint b) {
  return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
}