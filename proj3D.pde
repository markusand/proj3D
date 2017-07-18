WarpSurface surface;
final LatLon[] ROI = new LatLon[] {
    new LatLon(42.505085,1.509961),
    new LatLon(42.517067,1.544024),
    new LatLon(42.508160,1.549798),
    new LatLon(42.496162,1.515728)
};

Canvas canvas;
final LatLon[] bounds = new LatLon[] {
    new LatLon(42.5181, 1.50803),
    new LatLon(42.495, 1.55216)
};


void setup() {
    size(900, 700, P2D);
    
    canvas = new Canvas(this, "orto_epsg3857.jpg", bounds);
    surface = new WarpSurface(this, 700, 300, 6, 3, ROI);
    //surface = new WarpSurface(this, "surface.xml");
    
}


void draw() {

    background(0);
    surface.draw(canvas);
    
}


void keyPressed() {
    switch(key) {
        case 's':
            surface.saveConfig("surface.xml");
            break;
        
        case 'l':
            surface.loadConfig("surface.xml");
            break;
        
        case 'w':
            surface.toggleCalibration();
            break;
    }
} 