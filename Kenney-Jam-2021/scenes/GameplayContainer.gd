extends Node
class_name GameplayContainer

#CONSTS
const MAIN_MENU_PATH = "res://scenes/MainMenu.tscn"
const END_SCREEN_PATH = "res://scenes/EndMenu.tscn"

#EXPORT VARS
export(NodePath) var FIRST_BUTTON_PATH = NodePath("HudLayer/PauseMenu/VBoxContainer/BtnResume")

#ONREADY VARS
onready var _levelLayer = $LevelLayer
onready var _deathScreen : Control = $HudLayer/DeathScreen
onready var _animationPlayer : AnimationPlayer = $AnimationPlayer
onready var _pauseScreen : Control = $HudLayer/PauseMenu
onready var _levelChangeDelay : Timer = $LevelChangeDelay
onready var _audioGoalReached : AudioStreamPlayer = $AudioGoalReached
onready var _audioRotate : AudioStreamPlayer = $AudioRotate

func _ready():
	_load_level()

func _on_level_complete():
	var level_to_load : int = ProjectSettings.get("tinyicedungeon/level_select/current_level") + 1
	ProjectSettings.set("tinyicedungeon/level_select/current_level", level_to_load)
	_load_level()

func _next_level():
	_audioGoalReached.play()
	_levelChangeDelay.start()

func _load_level():
	#Load level
	var level_to_load : int = ProjectSettings.get("tinyicedungeon/level_select/current_level")
	var array_levels : Array = ProjectSettings.get("tinyicedungeon/level_select/levels_available")
	if(!(level_to_load >= 0 && level_to_load < array_levels.size())):
		get_tree().change_scene(END_SCREEN_PATH)
		return
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
		rot_tile_map.connect("goal_reached", self, "_next_level")
		rot_tile_map.connect("rotate_clockwise", self, "anim_rotate_clockwise")
		rot_tile_map.connect("rotate_counter_clockwise", self, "anim_rotate_counter_clockwise")
		rot_tile_map.connect("player_died", self, "_player_died")
		rot_tile_map.connect("reset", self, "_reset")
		result = true
		
	return result

func anim_rotate_clockwise():
	_animationPlayer.stop(true)
	_animationPlayer.play("Rotate_Counter_Clockwise")
	_audioRotate.play()

func anim_rotate_counter_clockwise():
	_animationPlayer.stop(true)
	_animationPlayer.play("Rotate_Clockwise")
	_audioRotate.play()

func _player_died():
	_deathScreen.visible = true

func _reset():
	_deathScreen.visible = false

func toggle_pause():
	if(_pauseScreen.visible):
		_pauseScreen.visible = false
		get_tree().paused = false
	else:
		_pauseScreen.visible = true
		get_tree().paused = true
		get_node(FIRST_BUTTON_PATH).grab_focus()

func _input(event):
	if(event.is_action_pressed("pause")):
		toggle_pause()


func _on_BtnQuit_pressed():
	get_tree().paused = false
	get_tree().change_scene(MAIN_MENU_PATH)
