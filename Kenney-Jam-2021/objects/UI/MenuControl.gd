extends CenterContainer

export(NodePath) var BUTTON_CONTAINER_PATH = NodePath("MenuContainer/ButtonsContainer/HAlign")

func _ready():
	var firstBtn = get_node(BUTTON_CONTAINER_PATH).get_children()
	firstBtn[0].grab_focus()
