/*  ODEx
 *  Ira Winder, ira@mit.edu, 2018
 *
 *  ODEx is tool for visualization and exploration of origin destination (OD) data. In
 *  this example, OD data is placed in the "data/" folder in the form of two CSV files:
 *
 *  A. "nodes.csv" - A table where each row represents a node in a network. Each row 
 *     contains three columns of information: Node ID, Latitude, and Longitude. For
 *     example: "0, 41.22, -1.44
 *              "1, 41.21, -1.45 ... "
 *              
 *  B. "od_pairs.csv" - A table where each row represents the agregate trips between two
 *     nodes in the network over a specified time. Each row contains three columns of 
 *     information: Origin Node ID, Destination Node ID, and trip count. For
 *     example: "0, 0, 40      <-  40 trips were stationary at node 0
 *              "1, 0, 3       <-  3 trips from node 1 to node 1
 *              "0, 1, 5 ... "            
 *
 *  MIT LICENSE: Copyright 2018 Ira Winder
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
 
 public void settings() {
  size(1280, 800, P3D);
  //fullScreen(P3D);
}

// Runs once when application begins
//
void setup() {
  
}

// Runs on a infinite loop after setup
//
void draw() {
  if (!initialized) {
    
    // A_Init.pde - runs until initialized = true
    //
    init();
    
  } else {
    
    // A_Listen.pde - Updates settings and values for this frame
    //
    listen();
    
    // A_Render.pde - Renders current frame of visualization
    //
    background(0);
    render3D();
    render2D();
  }
}
