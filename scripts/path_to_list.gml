///path_to_list( path )

var path = argument0;
var closed = path_get_closed( path );
var points = path_get_number( path );

var list = ds_list_create();

for( var i = 0; i < points + closed; i++ ) {
    var iLoop = ( i + 1 ) mod points;
    ds_list_add( list, path_get_point_x( path, i ), path_get_point_y( path, i ) );
}

return list;
