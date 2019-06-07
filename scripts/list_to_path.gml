///list_to_path( list, closed )

var list = argument0;
var closed = argument1;
var points = ds_list_size( list );

var path = path_add();

for( var i = 0; i < points - closed * 2; i += 2 ) {
    var iLoop = ( i + 1 ) mod points;
    path_add_point( path, list[| i], list[| i+1], 100 );
}

return path;
