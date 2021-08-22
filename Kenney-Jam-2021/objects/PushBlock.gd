extends Player

var can_interact := true

func _ready():
	piece_type = Types.PUSH_BLOCK
	handle_inputs = false
	handle_physics_process = false
	add_to_group(GROUP_ROTATE)
	add_to_group(GROUP_MOVEABLE)

func interact():
	if(!can_interact):
		return false
	var player : Player = _tileMap.player
	direction = player.direction
	_timer.start()
	return true

func reset():
	.reset()
	piece_type = Types.PUSH_BLOCK
	can_interact = true

func fall():
	_timer.stop()
	set_physics_process(false)
	_play_audio(_audioFall)
	_animPlayer.play("Fall")
	piece_type = -1
	can_interact = false

func is_moving()->bool:
	return !_timer.is_stopped()
	

#This is PushBlock specific logic to to facilitate hitting switches when sliding against them
func _can_move_to_grid_pos(grid_pos:Vector2)->bool:
	var result = true;
	var object = _rayCast.get_chess_piece_object(Vector2() + (direction * cell_size))
	if(object != null):
		match(object.piece_type):
			Types.PUSH_BLOCK:
				result = false;
			Types.SWITCH:
				object.interact()
				result = false;
			Types.CLOSED_DOOR:
				result = false;
	match(_tileMap.get_cell(grid_pos.x, grid_pos.y)):
		WALL_ID:
			result = false;
	return result;
