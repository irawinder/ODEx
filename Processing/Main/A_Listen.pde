/*  ODEx
 *  Ira Winder, ira@mit.edu, 2018
 *
 *  Listen Functions (Superficially Isolated from Main.pde)
 *
 *  MIT LICENSE:  Copyright 2018 Ira Winder
 *
 *               Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 *               and associated documentation files (the "Software"), to deal in the Software without restriction, 
 *               including without limitation the rights to use, copy, modify, merge, publish, distribute, 
 *               sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
 *               furnished to do so, subject to the following conditions:
 *
 *               The above copyright notice and this permission notice shall be included in all copies or 
 *               substantial portions of the Software.
 *
 *               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 *               NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 *               DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 *               OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
void listen() {
  
  countMinThreshold = bar_left.sliders.get(0).value;
  countMaxThreshold = bar_left.sliders.get(1).value;
  
  if (bar_left.sliders.get(2).value > 0) {
    countScaler = bar_left.sliders.get(2).value;
  } else if (bar_left.sliders.get(2).value < 0) {
    countScaler = 1.0 / abs(bar_left.sliders.get(2).value);
  } else {
    countScaler = 1;
  }
  
  showIntraNodal = bar_left.buttons.get(0).value;
  showInterNodal = bar_left.buttons.get(1).value;
  showID    = bar_left.buttons.get(2).value;
  showRoads = bar_left.buttons.get(3).value;
  edges3d   = bar_left.buttons.get(4).value;
}

void mousePressed() {
  if (initialized) {
    cam.pressed();
    bar_left.pressed();
    bar_right.pressed();
  }
}

void mouseDragged() {
  if (initialized) {
    
  }
}

void mouseReleased() {
  if (initialized) {
    bar_left.released();
    bar_right.released();
  }
}

void mouseMoved() {
  if (initialized) {
    cam.moved();
  }
}

void keyPressed() {
  if (initialized) {
    cam.moved();
    bar_left.pressed();
    bar_right.pressed();
    
    switch(key) {
      case 'f':
        cam.showFrameRate = !cam.showFrameRate;
        break;
      case 'c':
        cam.reset();
        break;
      case 'r':
        bar_left.restoreDefault();
        bar_right.restoreDefault();
        break;
      case 'p':
        println("cam.offset.x = " + cam.offset.x);
        println("cam.offset.y = " + cam.offset.y);
        println("cam.zoom = "     + cam.zoom);
        println("cam.rotation = " + cam.rotation);
        break;
    }
  }
}

boolean barHover() {
  boolean hoverLeft  = mouseX > bar_left.barX  && mouseX < bar_left.barX+bar_left.barW   && mouseY > bar_left.barY  && mouseY < bar_left.barY+bar_left.barH;
  boolean hoverRight = mouseX > bar_right.barX && mouseX < bar_right.barX+bar_right.barW && mouseY > bar_right.barY && mouseY < bar_right.barY+bar_right.barH;
  return hoverLeft || hoverRight;
}
