extends ChessPiece

#CONSTS
const WALL_ID = 0
const VICTORY_ID = 1

#ONREADY VARS
onready var _timer : Timer = $MovementTimer

#GLOBAL VARS
var direction := Vector2() #Current moving direction


func _physics_process(delta):
	direction = _get_input_direction()
	_handle_current_tile()
	_handle_movement()

func _handle_current_tile():
	_update_grid_position()
	match(_tileMap.get_cell(grid_position.x, grid_position.y)):
		VICTORY_ID:
			visible = false

func _handle_movement():
	_update_grid_position()
	if(direction == Vector2()):
		return
	var new_grid_position = grid_position + direction
	if(_can_move_to_grid_pos(new_grid_position)):
		position += direction * cell_size
		_center_position_on_grid()
		set_physics_process(false)
		_timer.start()
	else:
		_timer.stop()
		set_physics_process(true)
	
func _can_move_to_grid_pos(grid_pos:Vector2)->bool:
	var result = true;
	match(_tileMap.get_cell(grid_pos.x, grid_pos.y)):
		WALL_ID:
			result = false;
	return result;

#GETTERS AND SETTERS
func _get_standing_tile()->int:
	var result = _tileMap.get_cell(grid_position.x, grid_position.y)
	return result

func _get_input_direction()->Vector2:
	var direction = Vector2()
	if Input.is_action_just_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_just_pressed("ui_down"):
		direction.y += 1
	elif Input.is_action_just_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_just_pressed("ui_right"):
		direction.x += 1
	return direction.normalized()


func _on_MovementTimer_timeout():
	_handle_current_tile()
	_handle_movement()
	_timer.start()
