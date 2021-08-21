extends Control

onready var buttonContainer := $MenuContainer/ButtonsContainer/HAlign

func _ready():
	var firstBtn = buttonContainer.get_children()
	firstBtn[0].grab_focus()
