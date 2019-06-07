///path_create_smoothed( path, detail, tightness )
//  
//  Creates a new path based on an existing path, smoothed using Catmull-Rom interpolation.
//  
//  !!! Dependent on the script spline4(), available here: http://www.gmlscripts.com/script/spline4
//  
//  argument0: Basis path.
//  argument1: How detailed the output smoothed path is. Lower values are smoother.
//  argument2: How closely the new path follows the old path.
//             A value of 1 will return a path the follows the original with tight corners, a value of 0 will return a path with gentler corners.
//  
//  return   : If successful, the ID of the new path (return >= 0). If unsuccessful, returns "noone" (return = -4).

var path, detail, tightness, newClosed, closed, points, limit;
var x0, x1, x2, x3, y0, y1, y2, y3, i, iLoop;
var t, xx, yy, Ox, Oy;

path = argument0;
detail = argument1;
tightness = argument2;
newClosed = argument3;

points = path_get_number( pth_test );

if ( points < 3 ) {
    show_debug_message( "path_create_smoothed: too few points (" + string( points ) + ")! path=" + string( path ) );
    return noone;
}

closed = path_get_closed( pth_test );

newPath = path_add();

if ( detail <= 0 ) detail = 0.1;
detail = min( 1, detail );
tightness = clamp( tightness, 0, 1 );

if ( closed ) {
    
    x1 = path_get_point_x( pth_test, 0 );
    y1 = path_get_point_y( pth_test, 0 );
    x2 = path_get_point_x( pth_test, 1 );
    y2 = path_get_point_y( pth_test, 1 );
    x3 = path_get_point_x( pth_test, 2 );
    y3 = path_get_point_y( pth_test, 2 );
    
    for( i = 0; i < points; i++ ) {
        iLoop = ( i + 3 ) mod points;
        
        x0 = x1; y0 = y1;
        x1 = x2; y1 = y2;
        x2 = x3; y2 = y3;
        x3 = path_get_point_x( pth_test, iLoop );
        y3 = path_get_point_y( pth_test, iLoop );
        
        for( t = 0; t < 1; t += detail ) {
            xx = spline4( t, x0, x1, x2, x3 );
            yy = spline4( t, y0, y1, y2, y3 );
            Ox = lerp( x1, x2, t );
            Oy = lerp( y1, y2, t );
            xx = lerp( xx, Ox, tightness );
            yy = lerp( yy, Oy, tightness );
            path_add_point( newPath, xx, yy, lerp( path_get_point_speed( path, i ), path_get_point_speed( path, ( i + 1 ) mod points ), t ) );
        }
        
    }
    
    path_set_closed( newPath, true );
    
} else {
    
    x1 = path_get_point_x( pth_test, 0 );
    y1 = path_get_point_y( pth_test, 0 );
    x2 = path_get_point_x( pth_test, 0 );
    y2 = path_get_point_y( pth_test, 0 );
    x3 = path_get_point_x( pth_test, 1 );
    y3 = path_get_point_y( pth_test, 1 );
    
    for( i = 0; i < points - 1; i++ ) {
        iLoop = min( points - 1, i + 2 );
        
        x0 = x1; y0 = y1;
        x1 = x2; y1 = y2;
        x2 = x3; y2 = y3;
        x3 = path_get_point_x( pth_test, iLoop );
        y3 = path_get_point_y( pth_test, iLoop );
        
        for( t = 0; t < 1; t += detail ) {
            xx = spline4( t, x0, x1, x2, x3 );
            yy = spline4( t, y0, y1, y2, y3 );
            Ox = lerp( x1, x2, t );
            Oy = lerp( y1, y2, t );
            xx = lerp( xx, Ox, tightness );
            yy = lerp( yy, Oy, tightness );
            path_add_point( newPath, xx, yy, lerp( path_get_point_speed( path, i ), path_get_point_speed( path, i + 1 ), t ) );
        }
        
    }
    
    path_add_point( newPath, path_get_point_x( path, points - 1 ), path_get_point_y( path, points - 1 ), path_get_point_speed( path, points - 1 ) );
    path_set_closed( newPath, false );
    
}

return newPath;
