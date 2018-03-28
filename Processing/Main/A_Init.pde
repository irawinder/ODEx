/*  ODEx
 *  Ira Winder, ira@mit.edu, 2018
 *
 *  Init Functions (Superficially Isolated from Main.pde)
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

// Data Objects for loading and storing Origin-Destination (OD) Data
//
Table od_nodes, od_pairs;
ArrayList<District> districts;
ArrayList<Commute>  commutes;
HashMap<Integer, District> districtHash;
float maxCount;

//  GeoLocation Parameters:
float latCtr, lonCtr, bound, latMin, latMax, lonMin, lonMax;

// Count Thresholds - Minimum and Maximum counts before displaying an OD pair
//
float countMinThreshold;
float countMaxThreshold;
float countScaler;
boolean showID, showIntraNodal, showInterNodal, showRoads, edges3d;

// Camera Object with built-in GUI for navigation and selection
//
Camera cam;
PVector B; // Bounding Box for 3D Environment
int MARGIN = 25; // Pixel margin allowed around edge of screen

// Semi-transparent Toolbar for information and sliders
//
Toolbar bar_left, bar_right; 
int BAR_X, BAR_Y, BAR_W, BAR_H;
Button simButton;

PFont f12, f18, f24;

// Counter to track which phase of initialization
//
boolean initialized;
int initPhase = 0;
int phaseDelay = 0;
String status[] = {
  "Initializing Canvas ...",
  "Loading OD Data ...",
  "Initializing Toolbars and 3D Environment ...",
  "Ready to go!"
};
int NUM_PHASES = status.length;

void init() {
  
  initialized = false;
    
  if (initPhase == 0) {
    
    // Load default background image
    //
    loadingBG = loadImage("data/loadingScreen.jpg");
    
    //Set Font
    //
    f12 = createFont("Helvetica", 12);
    f18 = createFont("Helvetica", 18);
    f24 = createFont("Helvetica", 24);
    textFont(f12);
    
    // Create canvas for drawing everything to earth surface
    //
    B = new PVector(1000, 1000, 100);
    
  } else if (initPhase == 1) {
    
    // Init OD Viewing Parameters
    // 
    countMinThreshold = 0;
    countMaxThreshold = Float.POSITIVE_INFINITY;
    countScaler = 0;
    showInterNodal = true;
    showIntraNodal = true;
    showID = true;
    showRoads = true;
    
    // Load OD Data
    //
    initOD();
    
  } else if (initPhase == 2) {
    
    // Initialize GUI3D
    //
    initToolbars();
    initCamera();
    
  } else if (initPhase == 3) {
    
    initialized = true;
  }
  
  loadingScreen(loadingBG, initPhase, NUM_PHASES, status[initPhase]);
  if (!initialized) initPhase++; 
  delay(phaseDelay);

}

void initCamera() {
  // Initialize the Camera
    // cam = new Camera(toolbar_width, b, -350, 50, 0.7, 0.1, 2.0, 0.45);
    // Initialize 3D World Camera Defaults
    cam = new Camera (B, MARGIN);
    // eX, eW (extentsX ...) prevents accidental dragging when interactiong with toolbar
    cam.eX = bar_left.barX + bar_left.barW;
    cam.eW = width - (bar_left.barW + bar_right.barW + 2*MARGIN);
    cam.X_DEFAULT    = -86;
    cam.Y_DEFAULT    = 580;
    cam.ZOOM_DEFAULT = 1.50;
    cam.ZOOM_POW     = 2.50;
    cam.ZOOM_MAX     = 0.25;
    cam.ZOOM_MIN     = 1.80;
    cam.ROTATION_DEFAULT = PI; // (0 - 2*PI)
    cam.enableChunks = false;  // Enable/Disable 3D mouse cursor field for continuous object placement
    cam.init(); //Must End with init() if any variables within Camera() are changed from default
    cam.off(); // turn cam off while still initializing
}

void initToolbars() {
  
  // Initialize Toolbar
  BAR_X = MARGIN;
  BAR_Y = MARGIN;
  BAR_W = 250;
  BAR_H = 800 - 2*MARGIN;
  
  // Left Toolbar
  bar_left = new Toolbar(BAR_X, BAR_Y, BAR_W, BAR_H, MARGIN);
  bar_left.title = "ODEx Beta 0.9";
  bar_left.credit = "\nHuman Dynamics";
  bar_left.explanation = "\n\nUse ODEx (Origin-Destination Explorer) for preliminary exploration of an OD data set." + 
                         "\n\nTo view your own data set, locate the 'data/' folder and replace 'nodes.csv' and 'od_pairs.csv' using the example data format." +
                         "\n\nThe area of lines an circles is proportion to the total counts represented." +
                         "\n\nThresholds: Use 'q', 'w', 'a', and 's' keys to fine-tune thresholds for which to display counts:";
  bar_left.controlY = BAR_Y + bar_left.margin + int(11*bar_left.CONTROL_H);
  
  bar_left.addSlider("Minimim Count Threshold", "",     0,  int(maxCount),             5, 'q', 'w', true);
  bar_left.addSlider("Maximum Count Threshold", "",     0,  int(maxCount), int(maxCount), 'a', 's', true);
  bar_left.addSlider("Visualization Scaler",    "",   -100,             100,           0, 'z', 'x', false);
  
  bar_left.addButton("Show Stationary Commutes"   ,   #FF00FF, true, '1');
  bar_left.addButton("Show Dynamic Commutes"      ,   #00FF00, true, '2');
  bar_left.addButton("Show Node IDs"              ,   200, false, '3');
  bar_left.addButton("Show Roads"                 ,   200, true, '4');
  bar_left.addButton("3D Edges"                   ,   200, true, '5');
  
  // Right Toolbar
  bar_right = new Toolbar(width - (BAR_X + BAR_W), BAR_Y, BAR_W, BAR_H, MARGIN);
  bar_right.title = "Summary / Analytics (TBA)";
  bar_right.credit = "";
  bar_right.explanation = "";
  bar_right.controlY = BAR_Y + bar_right.margin + 2*bar_right.CONTROL_H;
  
  //bar_right.addSlider("Slider 3", "",  1,  100, 1, 'q', 'w', false);
  //bar_right.addButton("Radio Button 1", 200, true, '1');
}

void initOD() {
  
  //  Parameter Space for Geometric Area (Beijing)
  //
  latCtr = +39.9042;
  lonCtr = +116.4047;
  bound    =  0.200;
  latMin = latCtr - bound;
  latMax = latCtr + bound;
  lonMin = lonCtr - bound;
  lonMax = lonCtr + bound;
  
  //  Initialize Districts (i.e. i.e. Nodes)
  //
  districts = new ArrayList<District>();
  districtHash = new HashMap<Integer, District>();
  od_nodes = loadTable("nodes.csv", "header");
  for (int i=0; i<od_nodes.getRowCount(); i++) {
    District d = new District();
    d.ID = od_nodes.getInt(i, "districtID");
    d.latlon.x = od_nodes.getFloat(i, "Latitude");
    d.latlon.y = od_nodes.getFloat(i, "Longitude");
    d.location = latlonToXY(d.latlon, latMin, latMax, lonMin, lonMax, 0, 0, B.x, B.y);
    districts.add(d);
    districtHash.put(d.ID, d);
  }
  println(districts.size() + " nodes loaded");
  
  //  Initialize Commutes (i.e. Edges)
  //
  commutes = new ArrayList<Commute>();
  od_pairs = loadTable("od_pairs.csv", "header");
  maxCount = 0;
  for (int i=0; i<od_pairs.getRowCount(); i++) {
    
    int originID      = od_pairs.getInt(i, 0);
    int destinationID = od_pairs.getInt(i, 1);
    float count       = od_pairs.getFloat(i, 2);
    
    Commute c = new Commute();
    c.origin      = districtHash.get(originID);
    c.destination = districtHash.get(destinationID);
    c.count       = count;
    
    if (count > maxCount) maxCount = count;
    
    commutes.add(c);
  }
  println(commutes.size() + " aggregated OD pairs loaded");
}

// Converts latitude, longitude to local friendly screen units (2D or 3D)
PVector latlonToXY(PVector latlon, float latMin, float latMax, float lonMin, float lonMax, float xMin, float yMin, float xMax, float yMax) {
  float X_Width = xMax - xMin;
  float Y_Width = yMax - yMin;
  float lat_scaler = (latlon.x - latMin) / abs(latMax - latMin);
  float lon_scaler = (latlon.y - lonMin) / abs(lonMax - lonMin);
  float X  = xMin + X_Width * lon_scaler;
  float Y  = yMin - Y_Width * lat_scaler + Y_Width;
  return new PVector(X,Y);
}
