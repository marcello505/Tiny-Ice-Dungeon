extends Player

func _ready():
	piece_type = Types.PUSH_BLOCK
	handle_inputs = false
	add_to_group(GROUP_ROTATE)

func interact():
	var player : Player = _tileMap.player
	direction = player.direction
	_timer.start()
	return true

func fall():
	visible = false
	_timer.stop()
	set_physics_process(false)


