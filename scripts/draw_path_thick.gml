///draw_path_manual( path, x, y, absolute )
//  
//  Draws a non-curved path with a thicker line.
//  It would seem 1.4.1657 has a bug where paths over a certain length aren't drawn...
//  Manually drawing the paths fixes this bug and also adds extra clarity.
//  
//  Arguments echo the standard draw_path()

var path, xx, yy, absolute, Ax, Ay, Bx, By, i, iLoop, points, closed;

path = argument0;
xx = argument1;
yy = argument2;
absolute = argument3;

if ( absolute ) {
    xx = 0;
    yy = 0;
} else {
    xx -= path_get_point_x( path, 0 );
    yy -= path_get_point_y( path, 0 );
}

points = path_get_number( path );
closed = path_get_closed( path );

Bx = path_get_point_x( path, 0 );
By = path_get_point_y( path, 0 );

for( i = 0; i < points + closed; i++ ) {
    var iLoop = ( i + 1 ) mod points;
    Ax = Bx;
    Ay = By;
    Bx = path_get_point_x( path, iLoop );
    By = path_get_point_y( path, iLoop );
    draw_line( Ax + xx    , Ay + yy    , Bx + xx    , By + yy     );
    draw_line( Ax + xx + 1, Ay + yy    , Bx + xx + 1, By + yy     );
    draw_line( Ax + xx    , Ay + yy + 1, Bx + xx    , By + yy + 1 );
}
