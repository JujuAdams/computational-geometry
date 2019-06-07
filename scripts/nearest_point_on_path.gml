///nearest_point_on_path( x, y, path, pathX, pathY, absolute )
//  
//  Finds the point on a path closest to an analysis point. Echoes the arguments and functionality of draw_path().
//  
//  !!! Will not give accurate results with curved paths.
//  
//  argument0:  x-coordinate of the analysis point.
//  argument1:  y-coordinate of the analysis point.
//  argument2:  Target path.
//  argument3:  Relative x-position of the path in the room (See draw_path).
//  argument4:  Relative y-position of the path in the room (See draw_path).
//  argument5:  If the path coordinates are relative or absolute (See draw_path).
//  
//  return   :  "true" if a point has been found, "false" otherwise.
//              {{global.nearest_point_on_path_x, global.nearest_point_on_path_y}} gives the position of the closest point on the path in absolute coordinates.

var xx, yy, path, pathX, pathY, absolute;
var closestLine, closestDist, closestX, closestY;
var closed, points, Ax, Ay, Bx, By;
var i, iLoop, dx, dy, lenSqr, t, Cx, Cy, perpDist;

xx       = argument0;
yy       = argument1;
path     = argument2;
pathX    = argument3;
pathY    = argument4;
absolute = argument5;

if ( !absolute ) {
    xx -= pathX - path_get_point_x( path, 0 );
    yy -= pathY - path_get_point_y( path, 0 );
}

closestLine = noone;
closestDist = 999999;
closestX = noone;
closestY = noone;

points = path_get_number( path );
closed = path_get_closed( path );
Bx = path_get_point_x( path, 0 );
By = path_get_point_y( path, 0 );

for( i = 1; i < points + closed; i++ ) {
    iLoop = i mod points;
    
    Ax = Bx;
    Ay = By;
    Bx = path_get_point_x( path, iLoop );
    By = path_get_point_y( path, iLoop );
    
    dx = Bx - Ax;
    dy = By - Ay;
    lenSqr = sqr( dx ) + sqr( dy );
    if ( lenSqr == 0 ) t = -1 else t = dot_product( xx - Ax, yy - Ay,   dx, dy ) / lenSqr;
    
    if ( t < 0 ) {
        Cx = Ax;
        Cy = Ay;
    } else if ( t > 1 ) {
        Cx = Bx;
        Cy = By;
    } else {
        Cx = Ax + t * dx;
        Cy = Ay + t * dy;
    }
    
    var perpDist = point_distance( xx, yy,   Cx, Cy );
    
    if ( perpDist < closestDist ) {
        closestLine = i;
        closestDist = perpDist;
        closestX = Cx;
        closestY = Cy;
    }
    
}

if ( closestLine != noone ) {
    
    if ( !absolute ) {
        closestX += pathX - path_get_point_x( path, 0 );
        closestY += pathY - path_get_point_y( path, 0 );
    }
    
    global.nearest_point_on_path_x = closestX;
    global.nearest_point_on_path_y = closestY;
    return true;
    
}

return false;
