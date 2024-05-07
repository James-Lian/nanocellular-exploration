extends Sprite

func _on_Area2D_mouse_entered():
	material.set_shader_param("outline_width", 4)
	print('hi')

func _on_Area2D_mouse_exited():
	material.set_shader_param("outline_width", 0)

func _on_Area2D_input_event():
	pass
