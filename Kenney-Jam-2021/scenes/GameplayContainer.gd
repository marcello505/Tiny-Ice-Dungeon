extends Node
class_name GameplayContainer

#ONREADY VARS
onready var _levelLayer = $LevelLayer
onready var _deathScreen : Control = $HudLayer/DeathScreen
onready var _animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	_load_level()

func _on_level_complete():
	var level_to_load : int = ProjectSettings.get("tinyicedungeon/level_select/current_level") + 1
	ProjectSettings.set("tinyicedungeon/level_select/current_level", level_to_load)
	_load_level()

func _load_level():
	#Load level
	var level_to_load : int = ProjectSettings.get("tinyicedungeon/level_select/current_level")
	var array_levels : Array = ProjectSettings.get("tinyicedungeon/level_select/levels_available")
	assert(level_to_load >= 0 && level_to_load < array_levels.size())
	var level : PackedScene = load(array_levels[level_to_load])
	
	#Add level to scene
	for child in _levelLayer.get_children():
		child.queue_free()
	var level_instance := level.instance()
	_levelLayer.add_child(level.instance())
	
	#Connect signals of most recent added child.
	var signals_found = false;
	for child in _levelLayer.get_child(_levelLayer.get_child_count() - 1).get_children():
		if(_look_for_signals_on_node(child)):
			signals_found = true
	assert(signals_found)

func _look_for_signals_on_node(node : Node)->bool:
	var result := false;
	if(node.has_signal("goal_reached") && node.has_signal("player_died")):
		var rot_tile_map : RotatingTileMap = node
		rot_tile_map.connect("goal_reached", self, "_on_level_complete")
		rot_tile_map.connect("rotate_clockwise", self, "anim_rotate_clockwise")
		rot_tile_map.connect("rotate_counter_clockwise", self, "anim_rotate_counter_clockwise")
		rot_tile_map.connect("player_died", self, "_player_died")
		rot_tile_map.connect("reset", self, "_reset")
		result = true
		
	return result

func anim_rotate_clockwise():
	_animationPlayer.play("Rotate_Counter_Clockwise")

func anim_rotate_counter_clockwise():
	_animationPlayer.play("Rotate_Clockwise")

func _player_died():
	_deathScreen.visible = true

func _reset():
	_deathScreen.visible = false
