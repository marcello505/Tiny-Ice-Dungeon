extends Area2D
class_name ChessPiece, "res://imports/editor_icons/ChessPiece-icon.png"

#ENUMS
enum Types {
	PLAYER,
	GOAL
}


#ONREADY VARS
onready var _tileMap : TileMap = $".."
onready var _collision : CollisionShape2D

#EXPORTED VARS
export(NodePath) var COLLISIONSHAPE2D_NODE = NodePath("CollisionShape2D")

#GLOBAL VARS
var piece_type := -1
var cell_size : Vector2
var grid_position : Vector2

func _ready():
	cell_size = _tileMap.cell_size
	_center_position_on_grid()
	
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
