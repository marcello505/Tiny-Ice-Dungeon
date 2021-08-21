extends CenterContainer

func _process(_delta):
	#Center display
	var rect := get_viewport_rect()
	rect_pivot_offset = rect.size * 0.5
