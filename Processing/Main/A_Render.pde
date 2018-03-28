/*  ODEx
 *  Ira Winder, ira@mit.edu, 2018
 *
 *  Render Functions (Superficially Isolated from Main.pde)
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

// Begin Drawing 2D Elements
//
void render2D() {
  
  hint(DISABLE_DEPTH_TEST);
  cam.off();
  
  // Draw Slider Bars for Controlling Zoom and Rotation (2D canvas begins)
  cam.drawControls();

  // Draw Margin ToolBar
  //
  bar_left.draw();
  bar_right.draw();
  
}

// Begin Drawing 3D Elements
//
void render3D() {

  // ****
  // NOTE: Objects draw earlier in the loop will obstruct 
  // objects drawn afterward (despite alpha value!)
  // ****

  hint(ENABLE_DEPTH_TEST);
  
  // Update camera position settings for a number of frames after key updates
  if (cam.moveTimer > 0) {
    cam.moved();
  }

  // Draw and Calculate 3D Graphics 
  cam.on();

  //// Field: Draw Rectangular plane comprising boundary area 
  ////
  //fill(255, 50);
  //rect(0, 0, B.x, B.y);
  
  //// Field: Draw Selection Field
  ////
  //pushMatrix(); translate(0, 0, 1);
  //image(cam.chunkField.img, 0, 0, B.x, B.y);
  //popMatrix();
  
  // Draw Commute "Edges"
  //
  pushMatrix(); translate(0, 0, 1);
  fill(255, 100); stroke(255, 200);
  for (Commute c: commutes) {
    
    // Only Display Edges within User-defined thresholds
    if (c.count >= countMinThreshold && c.count <= countMaxThreshold) {
      
      PVector O = c.origin.location;
      PVector D = c.destination.location;
      
      // Draw INTER-nodal trip
      //
      if (c.origin.ID != c.destination.ID  && showInterNodal) {
        
        float distance = O.dist(D);
        float weight = countScaler*c.count/distance;
        float alpha = 100;
        stroke(#00FF00, alpha); strokeWeight(weight);  noFill();
        if (edges3d) {
          
          int SEGMENTS = 10;
          PVector increment = new PVector(D.x, D.y);
          increment.sub(O);
          increment.mult(1.0 / SEGMENTS);
          
          float dist = O.dist(D);
          
          PVector p1;
          p1 = new PVector(O.x, O.y);
          beginShape();
          for (int i=0; i<SEGMENTS; i++) {
            vertex(p1.x, p1.y, 0.25*dist*sin(i*PI/SEGMENTS));
            p1.add(increment);
          }
          endShape();
          
        } else {
          line(O.x, O.y, D.x, D.y);
        }
        
      // Draw INTRA-nodal Trip
      //
      } else if (c.origin.ID == c.destination.ID  && showIntraNodal) {
        float weight = countScaler*c.count;
        float diam = 2*sqrt(weight/PI);
        fill(#FF00FF, 100); noStroke();
        ellipse(O.x, O.y, diam, diam);
      }
    }
  }
  popMatrix();
  
  // Draw District Centroids
  //
  if (showID) {
    pushMatrix(); translate(0, 0, 2);
    stroke(255, 150); strokeWeight(1); noFill(); textAlign(CENTER, CENTER);
    //float diam = 15*pow(cam.zoom+1, 2);
    float diam = 32;
    for (District d: districts) {
      float x = d.location.x;
      float y = d.location.y;
      rect(x-diam/2, y-diam/2, diam, diam);
      fill(255); text(d.ID, x, y); noFill();
    }
    popMatrix();
  }
  
}

PImage loadingBG;
void loadingScreen(PImage bg, int phase, int numPhases, String status) {

  // Place Loading Bar Background
  //
  image(bg, 0, 0, width, height);
  pushMatrix(); 
  translate(width/2, height/2);
  int BAR_WIDTH  = 400;
  int BAR_HEIGHT =  48;
  int BAR_BORDER =  10;

  // Draw Loading Bar Outline
  //
  noStroke(); 
  fill(255, 200);
  rect(-BAR_WIDTH/2, -BAR_HEIGHT/2, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT/2);
  noStroke(); 
  fill(0, 200);
  rect(-BAR_WIDTH/2+BAR_BORDER, -BAR_HEIGHT/2+BAR_BORDER, BAR_WIDTH-2*BAR_BORDER, BAR_HEIGHT-2*BAR_BORDER, BAR_HEIGHT/2);

  // Draw Loading Bar Fill
  //
  float percent = float(phase+1)/numPhases;
  noStroke(); 
  fill(255, 150);
  rect(-BAR_WIDTH/2 + BAR_HEIGHT/4, -BAR_HEIGHT/4, percent*(BAR_WIDTH - BAR_HEIGHT/2), BAR_HEIGHT/2, BAR_HEIGHT/4);

  // Draw Loading Bar Text
  //
  textAlign(CENTER, CENTER); 
  fill(255);
  text(status, 0, 0);

  popMatrix();
}
