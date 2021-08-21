extends ChessPiece

class_name Door
#EXPORT VARS
export(bool) var door_starts_open = false

#ONREADY VARS
onready var _sprite : Sprite = $Sprite

func _ready():
	_default_door()
	add_to_group(GROUP_ROTATE)

func _default_door():
	if(door_starts_open):
		piece_type = Types.OPEN_DOOR
		_sprite.frame = 1
	else:
		piece_type = Types.CLOSED_DOOR
		_sprite.frame = 0

func toggle_door():
	if(piece_type == Types.CLOSED_DOOR):
		piece_type = Types.OPEN_DOOR
		_sprite.frame = 1
	else:
		piece_type = Types.CLOSED_DOOR
		_sprite.frame = 0

func reset():
	.reset()
	_default_door()
