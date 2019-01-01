/**
* Rendering context to draw defined by a bounding box. This bounding box will be used by a WarpSurface
* to select the Region Of Interest to draw as a texture.
* @author    Marc Vilella
* @version   1.1b
*/
public class Canvas extends PGraphics2D {

    public final LatLon[] BOUNDS;
    
    /*
    * Construct a rendering context defining coordinates bounding box and its size.
    * Bounding box is used as a reference for the Region of Interest (ROI) that will be
    * displayed in the surface.
    * @param parent    the sketch PApplet
    * @param w         the bounding box width
    * @param h         the bounding box height
    * @param bounds    the bounding box coordinates. Coordinates order is TL, TR, BR, BL
    */
    public Canvas(PApplet parent, int width, int height, LatLon[] bounds) {
        this.BOUNDS = bounds;
        setParent(parent);
        setPrimary(false);
        setPath(parent.dataPath(""));
        resize(width, height);
    }
    
    /*
    * Construct a rendering context defining coordinates bounding box and an initial image.
    * Bounding box is used as a reference for the Region of Interest (ROI) that will be
    * displayed in the surface
    * @param parent    the sketch PApplet
    * @param imgPath   the path to the image to render
    * @param bounds    the bounding box coordinates. Coordinates order is TL, TR, BR, BL
    */
    public Canvas(PApplet parent, String imgPath, LatLon[] bounds) {
        this(parent, 0, 0, bounds);
        PImage bg = loadImage(imgPath);
        resize(bg.width, bg.height);
        beginDraw();
        image(bg, 0, 0, this.width, this.height);
        endDraw();
    }
    
    
    /**
    * Resize the canvas to adjust horizontal and vertical ratio according to latitude and longitude distances
    * @param width    canvas width
    * @param height   canvas height
    */
    @Override
    public void resize(int width, int height) {
        float dX = BOUNDS[0].dist(BOUNDS[0].getLat(), BOUNDS[2].getLon(), GeoDatum.WGS84);
        float dY = BOUNDS[0].dist(BOUNDS[2].getLat(), BOUNDS[0].getLon(), GeoDatum.WGS84);
        float ratio = dX / dY;
        int w = ratio < 1 ? int(height * ratio) : width;
        int h = ratio < 1 ? height : int(width / ratio);
        setSize(w, h);
    }
    
    
    /**
    * Translate a matrix of geographic coordinates into a canvas x,y positions
    * @param locations    Matrix of geographic coordinates (lat, lon)
    * @return translated x,y position for every coordinate in matrix
    */
    public PVector[][] toScreen(LatLon[][] locations) {
        PVector[][] points = new PVector[locations.length][locations[0].length];
        for(int i = 0; i < points.length; i++) {
            points[i] = toScreen(locations[i]);
        }
        return points;
    }
    
    
    /**
    * Translate an array of geographic coordinates into a canvas x,y positions
    * @param locations    Array of geographic coordinates (lat, lon)
    * @return translated x,y position for every coordinate in array
    */
    public PVector[] toScreen(LatLon[] locations) {
        PVector[] points = new PVector[locations.length];
        for(int i = 0; i < points.length; i++) {
            points[i] = toScreen(locations[i]);
        }
        return points;
    }
    
    
    /**
    * Translate a latitude,longitude coordinate into a canvas x,y position
    * @param lat    Latitude coordinate of the location
    * @param lon    Longitude coordinate of the location
    * @return translated x,y position of the location
    */
    public PVector toScreen(float lat, float lon) {
        return toScreen(new LatLon(lat, lon));
    }
    
    
    /**
    * Translate a latitude,longitude coordinate into a canvas x,y position
    * @param location  Latitude and Longitude coordinates of the location
    * @return translated x,y position of the location
    */
    public PVector toScreen(LatLon location) {
        if(Geometry.inTriangle(location, BOUNDS[2], BOUNDS[0], BOUNDS[1])) {
            PVector projPoint = Geometry.linesIntersection(BOUNDS[0], location, BOUNDS[1], BOUNDS[2]);
            float r1 = PVector.sub(projPoint, BOUNDS[1]).mag() / PVector.sub(BOUNDS[1], BOUNDS[2]).mag();
            float r2 = PVector.sub(location, BOUNDS[0]).mag() / PVector.sub(projPoint, BOUNDS[0]).mag();
            PVector decProjPoint = PVector.lerp(new PVector(this.width, 0), new PVector(this.width, this.height), r1);
            return PVector.lerp(new PVector(0, 0), decProjPoint, r2);
        }
        if(Geometry.inTriangle(location, BOUNDS[2], BOUNDS[0], BOUNDS[3])) {
            PVector projPoint = Geometry.linesIntersection(BOUNDS[0], location, BOUNDS[3], BOUNDS[2]);
            float r1 = PVector.sub(projPoint, BOUNDS[3]).mag() / PVector.sub(BOUNDS[3], BOUNDS[2]).mag();
            float r2 = PVector.sub(location, BOUNDS[0]).mag() / PVector.sub(projPoint, BOUNDS[0]).mag();
            PVector decProjPoint = PVector.lerp(new PVector(0, this.height), new PVector(this.width, this.height), r1);
            return PVector.lerp(new PVector(0, 0), decProjPoint, r2);
        }
        return null;
    }
    
}
