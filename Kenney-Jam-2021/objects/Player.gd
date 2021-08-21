extends ChessPiece
class_name Player

#CONSTS
const PIT_ID = -1
const WALL_ID = 0
const DRY_PATCH_ID = 2

#ONREADY VARS
onready var _timer : Timer = $MovementTimer
onready var _rayCast : ChessPieceRayCast = $RayCast2D

#GLOBAL VARS
var direction := Vector2() #Current moving direction
var handle_inputs := true #If this object should act like a player but not take inputs then set this to false
var handle_physics_process := true

func _ready():
	piece_type = Types.PLAYER

func _physics_process(delta):
	if(!handle_physics_process):
		return
	_update_input_direction()
	if(!_interact()):
		_handle_movement()
	_handle_current_tile()

func _interact():
	if(direction == Vector2()):
		return false 
	var object = _rayCast.get_chess_piece_object(Vector2() + (direction * cell_size))
	if(object != null):
		return object.interact()
	else:
		return false
	
func _handle_current_tile():
	_update_grid_position()
	var object_type = _rayCast.get_chess_piece_object_type(Vector2())
	match(object_type):
		Types.GOAL:
			print("You Win!")
			_timer.stop()
			_tileMap.emit_signal("goal_reached")
	match(_tileMap.get_cell(grid_position.x, grid_position.y)):
		PIT_ID:
			fall()
		DRY_PATCH_ID:
			_timer.stop()
			direction = Vector2()
			set_physics_process(true)

func _handle_movement():
	_update_grid_position()
	if(direction == Vector2()):
		return
	if(_is_inside_wall()):
		#Don't move if you're stuck in a wall lmao
		print("You're stuck!")
		return
	
	var new_grid_position = grid_position + direction
	if(_can_move_to_grid_pos(new_grid_position)):
		position += direction * cell_size
		_center_position_on_grid()
		set_physics_process(false)
		_timer.start()
	else:
		direction = Vector2()
		_timer.stop()
		set_physics_process(true)
	

func _is_inside_wall()->bool:
	var result = false;
	var object_type = _rayCast.get_chess_piece_object_type(Vector2())
	match(object_type):
		Types.PUSH_BLOCK:
			result = true
		Types.SWITCH:
			result = true
		Types.CLOSED_DOOR:
			result = true
	match(_tileMap.get_cell(grid_position.x, grid_position.y)):
		WALL_ID:
			result = true
	return result

func _can_move_to_grid_pos(grid_pos:Vector2)->bool:
	var result = true;
	var object_type = _rayCast.get_chess_piece_object_type(Vector2() + (direction * cell_size))
	match(object_type):
		Types.PUSH_BLOCK:
			result = false;
		Types.SWITCH:
			result = false;
		Types.CLOSED_DOOR:
			result = false;
	match(_tileMap.get_cell(grid_pos.x, grid_pos.y)):
		WALL_ID:
			result = false;
	return result;

#GETTERS AND SETTERS
func _get_standing_tile()->int:
	var result = _tileMap.get_cell(grid_position.x, grid_position.y)
	return result

func _update_input_direction():
	if(!handle_inputs):
		return
	
	direction = Vector2()
	if (Input.is_action_just_pressed("rotate_clockwise")):
		_tileMap.rotate_clockwise()
	elif(Input.is_action_just_pressed("rotate_counter_clockwise")):
		_tileMap.rotate_counter_clockwise()
	else:
		if Input.is_action_just_pressed("ui_up"):
			direction.y -= 1
		elif Input.is_action_just_pressed("ui_down"):
			direction.y += 1
		elif Input.is_action_just_pressed("ui_left"):
			direction.x -= 1
		elif Input.is_action_just_pressed("ui_right"):
			direction.x += 1


func _on_MovementTimer_timeout():
	_handle_movement()
	_handle_current_tile()

func reset():
	.reset()
	visible = true
	direction = Vector2()
	_timer.stop()
	set_physics_process(true)
	
#AAAAAAAAH I'M FALLING
func fall():
	visible = false
	_timer.stop()
	set_physics_process(false)
	_tileMap.emit_signal("player_died")
