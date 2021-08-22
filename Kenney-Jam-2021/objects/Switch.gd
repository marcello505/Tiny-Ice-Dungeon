extends ChessPiece
class_name Switch

#EXPORT VARS
export(NodePath) var DOOR_NODE 

#ONREADY VARS
onready var _sprite : Sprite = $Sprite

func _ready():
	piece_type = Types.SWITCH
	add_to_group(GROUP_ROTATE)

func interact():
	match(_sprite.frame):
		0:
			_sprite.frame = 1
		1:
			_sprite.frame = 0
	
	var door : Door = get_node(DOOR_NODE)
	if(door != null):
		door.toggle_door()

func reset():
	.reset()
	_sprite.frame = 0;
