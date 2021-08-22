extends HSlider



func _ready():
	value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
