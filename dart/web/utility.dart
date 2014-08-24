library utility;

import 'dart:math';

num clamp(num a, num min_val, num max_val) {
  return max(min(a, max_val), min_val);
}
