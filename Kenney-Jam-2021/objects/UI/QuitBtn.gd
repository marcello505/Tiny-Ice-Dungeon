extends Button

func _ready():
	if OS.get_name() == "HTML5":
		disabled = true;

func _btn_Pressed():
	get_tree().quit()
