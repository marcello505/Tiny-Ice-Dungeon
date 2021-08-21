extends TileMap

#CONSTS
const KEY_ID = "id"
const KEY_COORD = "coord"
const KEY_AUTOTILE_COORD = "autotile_coord"

func _process(_delta):
	#Center display
	var rect := get_viewport_rect()
	position = rect.size * 0.5
	

func _physics_process(delta):
	if(Input.is_action_just_pressed("rotate_clockwise")):
		rotate_clockwise()
	if(Input.is_action_just_pressed("rotate_counter_clockwise")):
		rotate_counter_clockwise()

func rotate_clockwise():
	var array = _gather_info_cells()
	for item in array:
		item[KEY_COORD] = _calculate_clockwise_grid_rotation(item[KEY_COORD])
	_set_array_cells(array)

func rotate_counter_clockwise():
	var array = _gather_info_cells()
	for item in array:
		item[KEY_COORD] = _calculate_counter_clockwise_grid_rotation(item[KEY_COORD])
	_set_array_cells(array)

func _calculate_clockwise_grid_rotation(coord : Vector2)->Vector2:
	var result := Vector2()
	if(coord.x >= 0 && coord.y >= 0):
		#Bottom Right
		result.x = coord.y * -1 - 1
		result.y = coord.x
	elif(coord.x <= -1 && coord.y >= 0):
		#Bottom Left
		result.x = coord.y * -1 - 1
		result.y = coord.x
	elif(coord.x <= -1 && coord.y <= -1):
		#Top Left
		result.x = coord.y * -1 - 1
		result.y = coord.x
	elif(coord.x >= 0 && coord.y <= -1):
		#Top Right
		result.x = coord.y * -1 - 1
		result.y = coord.x
	return result

func _calculate_counter_clockwise_grid_rotation(coord : Vector2)->Vector2:
	var result := Vector2()
	if(coord.x >= 0 && coord.y >= 0):
		#Bottom Right
		result.y = coord.x * -1 - 1
		result.x = coord.y
	elif(coord.x <= -1 && coord.y >= 0):
		#Bottom Left
		result.y = coord.x * -1 - 1
		result.x = coord.y
	elif(coord.x <= -1 && coord.y <= -1):
		#Top Left
		result.y = coord.x * -1 - 1
		result.x = coord.y
	elif(coord.x >= 0 && coord.y <= -1):
		#Top Right
		result.y = coord.x * -1 - 1
		result.x = coord.y
	return result

func _set_array_cells(cells:Array):
	clear()
	for item in cells:
		var id:int = item[KEY_ID]
		var coord:Vector2 = item[KEY_COORD]
		var autotile_coord:Vector2 = item[KEY_AUTOTILE_COORD]
		set_cell(coord.x, coord.y, id, false, false, false, autotile_coord)

func _gather_info_cells()->Array:
	var result = []
	for i in get_used_cells():
		var coord = i;
		var id = get_cell(coord.x, coord.y)
		var autotile_coord = get_cell_autotile_coord(coord.x, coord.y)
		var dict = {KEY_COORD:coord, KEY_ID: id, KEY_AUTOTILE_COORD: autotile_coord}
		result.append(dict)
		
	return result
	
