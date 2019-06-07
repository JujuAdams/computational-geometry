///path_RDP_reduce( path, epsilon, destructive )
//  
//  Intelligently removes vertices from a path using the Ramer–Douglas–Peucker algorithm.
//  The R-D-P algorithm uses perpendicular distance to find "important" vertices and avoids cutting them out.
//  
//  !!! Will not give accurate results with curved paths (though it will still work).
//  
//  argument0:  Basis path.
//  argument1:  The aggressiveness of the algorithm.
//              Smaller values will keep more vertices, larger values will remove more vertices. Cannot be a negative nunber.
//  argument2:  Whether or not to destroy the basis path (argument0).
//  
//  return   :  A new path with roughly the same shape as the basis path but less vertices.


var pathIn = argument0;
var epsilon = max( 0, argument1 );
var destructive = argument2;

var closed = path_get_closed( pathIn );
var points = path_get_number( pathIn );

var Ax = path_get_point_x( pathIn, 0 );
var Ay = path_get_point_y( pathIn, 0 );
var Bx = path_get_point_x( pathIn, points - 1 );
var By = path_get_point_y( pathIn, points - 1 );
var startToEndDist = point_distance( Ax, Ay,   Bx, By );

if ( startToEndDist == 0 ) or ( points <= 2 ) {
    var maxDist = 0;
} else {
    
    var dx = Bx - Ax;
    var dy = By - Ay;
    var lenSqr = sqr( dx ) + sqr( dy );
    
    //Find maximum perpendicular distance between points {1, ..., n-1} and the line segment {1 -> n}
    var maxDist = 0;
    var maxIndex = noone;
    for( var i = 1; i < points - 1; i++ ) {
        
        var xx = path_get_point_x( pathIn, i );
        var yy = path_get_point_y( pathIn, i );
        
        if ( lenSqr == 0 ) var t = -1 else var t = dot_product( xx - Ax, yy - Ay,   dx, dy ) / lenSqr;
        
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
        
        if ( perpDist > maxDist ) {
            maxDist = perpDist;
            maxIndex = i;
        }
    }
}

var pathOut = path_add();

if ( maxDist > epsilon ) {
    
    var pathA = path_add();
    var pathB = path_add();
    
    for( var i = 0       ; i <= maxIndex; i++ ) path_add_point( pathA, path_get_point_x( pathIn, i ), path_get_point_y( pathIn, i ), path_get_point_speed( pathIn, i ) );
    for( var i = maxIndex; i < points   ; i++ ) path_add_point( pathB, path_get_point_x( pathIn, i ), path_get_point_y( pathIn, i ), path_get_point_speed( pathIn, i ) );
    
    pathA = path_RDP_reduce( pathA, epsilon, true );
    pathB = path_RDP_reduce( pathB, epsilon, true );
    
    var pointsA = path_get_number( pathA );
    var pointsB = path_get_number( pathB );
    for( var i = 0; i < pointsA - 1; i++ ) path_add_point( pathOut, path_get_point_x( pathA, i ), path_get_point_y( pathA, i ), path_get_point_speed( pathA, i ) );
    for( var i = 0; i < pointsB    ; i++ ) path_add_point( pathOut, path_get_point_x( pathB, i ), path_get_point_y( pathB, i ), path_get_point_speed( pathB, i ) );
    
    path_delete( pathA );
    path_delete( pathB );
    
} else {
    
    path_add_point( pathOut, Ax, Ay, path_get_point_speed( pathIn, 0 ) );
    path_add_point( pathOut, Bx, By, path_get_point_speed( pathIn, points - 1 ) );
    
}

path_set_closed( pathOut, closed );
if ( destructive ) path_delete( pathIn );
return pathOut;
