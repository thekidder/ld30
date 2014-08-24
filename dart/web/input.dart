library input;

import "dart:html";

class Input {
  int updown;
  int leftright;
  
  
  Input() {
    updown = 0;
    leftright = 0;
    
    window.onKeyUp.listen(this.onUp);
    window.onKeyDown.listen(this.onDown);
  }
  
  void onUp(KeyboardEvent event) {
    var keyEvent = new KeyEvent.wrap(event);
    switch(keyEvent.keyCode) {
      case KeyCode.LEFT:
        if(leftright < 0) leftright = 0;
        break;
      case KeyCode.RIGHT:
        if(leftright > 0) leftright = 0;
        break;
      case KeyCode.UP:
        if(updown < 0) updown = 0;
        break;
      case KeyCode.DOWN:
        if(updown > 0) updown = 0;
        break;
    }
  }
  
  void onDown(KeyboardEvent event) {
    var keyEvent = new KeyEvent.wrap(event);
    switch(keyEvent.keyCode) {
      case KeyCode.LEFT:
        leftright = -1;
        break;
      case KeyCode.RIGHT:
        leftright = 1;
        break;
      case KeyCode.UP:
        updown = -1;
        break;
      case KeyCode.DOWN:
        updown = 1;
        break;
    }
  }
}