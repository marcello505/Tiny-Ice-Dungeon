extends Button

export (String) var scene

func _btn_Pressed():
	get_tree().change_scene(scene)
