class OD_Node {
  
  // Unique integer index for node
  //
  int ID;                    
  
  // latidude and longitude of coordinate
  //
  PVector latlon; 
  
  // A "friendlier" location vector in local graphics units 
  // In 2D, upper left of screen is (0, 0)
  //
  PVector location;
  
  // When using mouse-hover commands in 3D, this variable 
  // should be updated with the 2D screen location of the mouse
  //
  PVector screenLocation;
  
  OD_Node() {
    ID = -1;
    latlon         = new PVector(0, 0);
    location       = new PVector(0, 0);
    screenLocation = new PVector(-1000, -1000);
  }
  
  // Find the location of the point on your screen (use for mouse commands)
  //
  void setScreen() {
    screenLocation.x = screenX(location.x, location.y, location.z);
    screenLocation.y = screenY(location.x, location.y, location.z);
  }
}

class OD_Pair {
  
  // Nodes of origin-destination (OD)
  OD_Node origin, destination;
  
  // Amount of aggregated trip counts between origin and destination nodes
  // Specify the units of time interval (i.e. 2 months)
  //
  float count;
  String unit_count;
  
  // Time at departure from origin and arrival and destination
  // Specify the units of trip counts   (i.e. 100s of commutes)
  //
  float time_O, time_D;
  String unit_time;
  
  OD_Pair() {
    
    origin      = new OD_Node();
    destination = new OD_Node();
    count       = 0;
    
    unit_count = "";
    unit_time  = "";
    
    time_O = 0;
    time_D = 1;
    unit_time = "";
  }
  
  OD_Pair(OD_Node origin, OD_Node destination, int count) {
    super();
    this.origin      = origin;
    this.destination = destination;
    this.count       = count;
  }
}

class District extends OD_Node {
  
  // "Friendly" name of the district
  //
  String name;
  
  // Residential and Floating Population of district
  //
  float popR, popF;
  String unit_popR, unit_popF;
  
  // Land Area of district
  //
  float area;
  String unit_area;
  
  // Mean Household Income
  //
  float hhI;
  String unit_hhI;
  
  // Economic Indicator
  //
  float econI;
  String unit_econI;
  
  District() {
    popR  = 0;   unit_popR  = "";
    popF  = 0;   unit_popF  = "";
    area  = 100; unit_area  = "";
    hhI   = 0;   unit_hhI   = "";
    econI = 0;   unit_econI = "";
  }
}

class Commute extends OD_Pair {
  
  Commute() {
    
  }
}
