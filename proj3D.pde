WarpSurface surface;
/*
final LatLon[] ROI = new LatLon[] {
    new LatLon(42.505085,1.509961),
    new LatLon(42.517067,1.544024),
    new LatLon(42.508160,1.549798),
    new LatLon(42.496162,1.515728)
};
*/

WarpCanvas canvas;
final LatLon[] bounds = new LatLon[] {
    new LatLon(42.5181, 1.50803),
    new LatLon(42.495, 1.50803),
    new LatLon(42.495, 1.55216),
    new LatLon(42.5181, 1.55216)
};


void setup() {
    size(900, 700, P2D);
    
    canvas = new WarpCanvas(this, "orto_epsg3857.jpg", bounds);
    //surface = new WarpSurface(this, 700, 300, 6, 3, ROI);
    surface = new WarpSurface(this, "surface.xml");
    
}


void draw() {

    background(0);
    surface.draw(canvas);
    
}


void mousePressed() {

    LatLon loc = surface.unmapPoint(mouseX, mouseY);
    println(loc);
    if(loc != null) {
        PVector pos = canvas.toScreen(loc.getLat(), loc.getLon());
        canvas.beginDraw();
        canvas.fill(#FF0000);
        canvas.ellipse(pos.x, pos.y, 10, 10);
        canvas.endDraw();
    }

}


void keyPressed() {
    switch(key) {
        case 'w':
            surface.toggleCalibration();
            break;
    }
} 
