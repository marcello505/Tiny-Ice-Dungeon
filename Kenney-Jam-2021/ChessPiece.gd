extends Node2D
class_name ChessPiece, "res://imports/editor_icons/ChessPiece-icon.png"

onready var _tileMap : TileMap = $".."

#GLOBAL VARS
var cell_size : Vector2
var grid_position : Vector2

func _ready():
	cell_size = _tileMap.cell_size;
	_center_position_on_grid()

func _update_grid_position():
	grid_position = _tileMap.world_to_map(position)

func _center_position_on_grid():
	var cell_size = _tileMap.cell_size
	position = _tileMap.map_to_world(_tileMap.world_to_map(position))
	position += cell_size * 0.5
