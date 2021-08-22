extends Area2D
class_name ChessPiece, "res://imports/editor_icons/ChessPiece-icon.png"

#ENUMS
enum Types {
	PLAYER,
	GOAL,
	PUSH_BLOCK,
	SWITCH,
	CLOSED_DOOR,
	OPEN_DOOR
}

#CONSTS
const GROUP_RESET = "reset"
const GROUP_ROTATE = "rotate"
const GROUP_MOVEABLE = "moveable"

#ONREADY VARS
onready var _tileMap : RotatingTileMap = $".."
onready var _collision : CollisionShape2D

#EXPORTED VARS
export(NodePath) var COLLISIONSHAPE2D_NODE = NodePath("CollisionShape2D")

#GLOBAL VARS
var starting_position : Vector2
var piece_type := -1
var cell_size : Vector2
var grid_position : Vector2

func _ready():
	cell_size = _tileMap.cell_size
	_center_position_on_grid()
	starting_position = position
	add_to_group(GROUP_RESET)
	
	#Automatically resize collisonshape
	_collision = get_node(COLLISIONSHAPE2D_NODE)
	_collision.shape.extents = cell_size * 0.25

func get_piece_type()->int:
	return piece_type

func _update_grid_position():
	grid_position = _tileMap.world_to_map(position)

func _center_position_on_grid():
	position = _tileMap.map_to_world(_tileMap.world_to_map(position))
	position += cell_size * 0.5

func reset():
	position = starting_position
	_update_grid_position()

func interact()->bool:
	#Subclasses can use this method to program some interaction logic.
	return false;

func rotate_clockwise():
	_update_grid_position()
	grid_position = _tileMap.calculate_clockwise_grid_rotation(grid_position)
	position = _tileMap.map_to_world(grid_position)
	_center_position_on_grid()
	

func rotate_counter_clockwise():
	_update_grid_position()
	grid_position = _tileMap.calculate_counter_clockwise_grid_rotation(grid_position)
	position = _tileMap.map_to_world(grid_position)
	_center_position_on_grid()
