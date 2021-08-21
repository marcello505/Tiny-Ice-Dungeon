extends ChessPiece
class_name Player

#CONSTS
const WALL_ID = 0
const VICTORY_ID = 1

#ONREADY VARS
onready var _timer : Timer = $MovementTimer
onready var _rayCast : RayCast2D = $RayCast2D

#GLOBAL VARS
var direction := Vector2() #Current moving direction


func _physics_process(delta):
	piece_type = Types.PLAYER
	direction = _get_input_direction()
	_handle_movement()

func _handle_current_tile():
	_update_grid_position()
	_rayCast.position = Vector2()
	if(_rayCast.is_colliding()):
		var object = _rayCast.get_collider()
		if(object.has_method("get_piece_type")):
			match(object.get_piece_type()):
				Types.GOAL:
					#Add win handling here.
					print("You Win!")
	else:
		match(_tileMap.get_cell(grid_position.x, grid_position.y)):
			_:
				pass

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
	_handle_movement()
	_handle_current_tile()