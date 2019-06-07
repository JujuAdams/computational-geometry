///path_from_image_outline( sprite, image, dummy object )
//  
//  Traces the outline of an image, creating a closed path as it goes.
//  This script uses a dummy object to help with the tracing/collision detection process.
//  This instance should be completely blank with no code and no events and should be set to "visible".
//  
//  !!! This script is moderately slow and should mostly be used at the start of a game.
//  !!! The output path has one vertex per pixel. It is recommended you reduce the number of vertices before use.
//  
//  argument0:  The sprite to trace. This sprite should have its collision mask set to "Precise".
//  argument1:  The image of the sprite to trace.
//  argument2:  A dummy container object, used to trigger collision events.
//              The instance created is automatically destroyed by the script.
//  
//  return   :  The outline path.

var spr, img, obj, inst, path, w, h, dx, dy, x0, y0, xN, yN;
spr = argument0;
img = argument1;
obj = argument2;

path = path_add();

inst = instance_create( 0, 0,   obj );
inst.sprite_index = spr;
inst.image_index = img;
w = sprite_get_width( spr );
h = sprite_get_height( spr );

dx[0] =  1; dy[0] =  0;
dx[1] =  1; dy[1] = -1;
dx[2] =  0; dy[2] = -1;
dx[3] = -1; dy[3] = -1;
dx[4] = -1; dy[4] =  0;
dx[5] = -1; dy[5] =  1;
dx[6] =  0; dy[6] =  1;
dx[7] =  1; dy[7] =  1;

y0 = h div 2;
for ( x0 = 0; x0 < w; x0++ ) if ( collision_point( x0, y0, inst, true, false ) ) break;

dir = 5;
xN = x0;
yN = y0;

do {
    
    path_add_point( path, xN, yN, 100 );
    
    repeat( 8 ) {
        dir = ( dir + 1 ) mod 8;
        if ( collision_point( xN + dx[dir], yN + dy[dir], inst, true, false ) ) {
            xN += dx[dir];
            yN += dy[dir];
            break;
        }
    }
    
    dir += 5;
    
} until ( xN == x0 ) and ( yN == y0);

path_set_closed( path, true );
with( inst ) instance_destroy();
return path;
