extends Button

const GAMEPLAY_CONTAINER_PATH = "res://scenes/GameplayContainer.tscn"

export(int) var level_select := 0



func _on_pressed():
	ProjectSettings.set("tinyicedungeon/level_select/current_level", level_select)
	get_tree().change_scene(GAMEPLAY_CONTAINER_PATH)
