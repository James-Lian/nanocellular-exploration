extends Light2D

func _ready():
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")

func reposition(nanobot_position, nanobot_rotation):
	$Image.position = -nanobot_position * $Image.scale
	$Cursor.rotation = nanobot_rotation

func _on_viewport_size_changed():
	position.x = OS.get_window_size().x - 115
	position.y = 115
