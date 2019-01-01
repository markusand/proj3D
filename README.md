# proj3D
Display projection into a 3D surface in Processing

Adjusting images projected from a beamer into a surface needs some perspective parametrization. A great option in Processing is using [Keystone library](https://github.com/davidbouchard/keystone) by [@davidbouchard](https://github.com/davidbouchard). However, this does not work when the surface to project on is irregular, where more options are needed to adjust control points and adapt them to the surface.

## Getting started
Create surface object that will allow to deform all its control points, and provide its vertices coordinates
```java
final LatLon[] ROI = new LatLon[] {
    new LatLon(42.505085,1.509961),
    new LatLon(42.517067,1.544024),
    new LatLon(42.508160,1.549798),
    new LatLon(42.496162,1.515728)
};

WarpSurface surface = new WarpSurface(this, 700, 300, 20, 10, ROI);

```

Create a canvas object to draw into and that will be used as the surface texture. Canvas must have defined its bounds coordinates, so the surface will select the area inside the Region of Interest
```java
final LatLon[] bounds = new LatLon[] {
    new LatLon(42.5181, 1.50803),
    new LatLon(42.495, 1.50803),
    new LatLon(42.495, 1.55216),
    new LatLon(42.5181, 1.55216)
};

WarpCanvas canvas = new WarpCanvas(this, 500, 300, bounds);
```

Draw into canvas as it would be done into any PGraphics object.
```java
canvas.beginDraw();
canvas.background(0);
canvas.fill(#FF0000);
canvas.noStroke();
canvas.ellipse(mouseX, mouseY, 5, 5);
canvas.endDraw();
```

Apply the canvas into the surface
```java
surface.draw(canvas);
```

Mapping from (lat,lon) location to (x,y) screen position and vice versa is possible through the given methods. If screen position or geographic location don't belong to surface, null value is returned
```java
PVector position = surface.mapPoint(42.246543, 1.568294);
LatLon location = surface.unmapPoint(mouseX, mouseY);
```

The WarpSurface is observable and returns the location of the clicked point (if the point is inside the surface's borders) to any class implementing the Observer interface that is observing it.


## Licensing
This project is licensed under the terms of the MIT license
