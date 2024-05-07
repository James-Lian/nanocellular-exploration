extends Node2D

onready var shader_outline = preload("Outline.tres")
onready var Sprites = $Sprites

onready var camera = $Camera2D

onready var label_box = $GUI/HUD/MarginContainer/Label
onready var next = $GUI/HUD/MarginContainer/Button

var panel_active = false
var camera_offset = Vector2()

var scan_mode = false # False is normal, True is scan

#game story variables
var organelles_to_learn = [
	"Membrane", 
	"Mitochondria", 
	"Nucleus", 
	"Ribosomes", 
	"Endoplasmic_Reticulum", 
	"Golgi_Apparatus", 
	"Microfilaments", 
	"Lysosome"
	]
###
var current_mission = 0

var text_list = []
var text_selection = 0

func _ready():
	$Collisions.show()
	$Mouse_Collisions.show()
	$GUI/HUD.show()
	
	for sprite in Sprites.get_children(): #setting a pre-defined shader
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = shader_outline
		sprite.material.set_shader_param("outline_color", Color("#ffd700"))
		set_outline(false, sprite)
	for i in range(1, 5):
		get_node("Lysosome" + str(i) + "/Sprite").material = ShaderMaterial.new()
		get_node("Lysosome" + str(i) + "/Sprite").material.shader = shader_outline
		get_node("Lysosome" + str(i) + "/Sprite").material.set_shader_param("outline_color", Color("#ffd700"))
		set_outline(false, get_node("Lysosome" + str(i) + "/Sprite"))

	for child in $Mouse_Collisions.get_children():
		child.connect("mouse_entered", self, "set_outline", [true, Sprites.get_node(str(child.get_name()))])
		child.connect("mouse_exited", self, "set_outline", [false, Sprites.get_node(str(child.get_name()))])
		child.connect("input_event", self, "organelle_clicked", [Sprites.get_node(str(child.get_name()))])
	for i in range(1, 5):
		get_node("Lysosome" + str(i) + "/Area2D").connect("mouse_entered", self, "set_outline", [true, get_node("Lysosome" + str(i) + "/Sprite")])
		get_node("Lysosome" + str(i) + "/Area2D").connect("mouse_exited", self, "set_outline", [false, get_node("Lysosome" + str(i) + "/Sprite")])
		get_node("Lysosome" + str(i) + "/Area2D").connect("input_event", self, "organelle_clicked", [get_node("Lysosome1")])
	
	next.connect("pressed", self, "next_pressed")
	$GUI/HUD/NinePatchRect/MarginContainer/TextureButton.connect("pressed", self, "scan_mode_toggle")
	$GUI/HUD/NinePatchRect/MarginContainer/TextureButton.material.set_shader_param("outline_color", Color("#ffd700"))
	
	$GUI/HUD.set_label_text("You have just landed in a cell. You are currently traveling in the cell's cytoplasm.")
	
	yield(get_tree().create_timer(2.0), "timeout")
	$Panel.info_panel("Cytoplasm")

func _physics_process(_delta):
	set_camera()
	$GUI/HUD/Minimap.reposition($Nanobot.position, $Nanobot.rotation)

func set_camera():
	if panel_active == true: 
		camera.position = $Nanobot.position + Vector2(camera_offset / 2)
	else:
		camera.position = $Nanobot.position

func panel_activated(offset, active):
	camera_offset.x = offset
	panel_active = active

func set_outline(on_off, sprite):
	if scan_mode == true:
		if on_off == true:
			sprite.material.set_shader_param("outline_width", 4)
		else:
			sprite.material.set_shader_param("outline_width", 0)
	else:
		sprite.material.set_shader_param("outline_width", 0)

func organelle_clicked(_viewport, event, _shape_idx, sprite):
	if scan_mode == true:
		if event is InputEventMouseButton and event.pressed:
			$Panel.info_panel(str(sprite.get_name()))
			if current_mission == 1:
				if sprite.get_name() == "Lysosome1" or sprite.get_name() == "Lysosome2" or sprite.get_name() == "Lysosome3" or sprite.get_name() == "Lysosome4":
					mission1("L")
				else:
					mission1(str(sprite.get_name()))

func start_mission_dialogue():
	if current_mission == 0:
		text_list = ["As a nanobot sent into a human cell, your assignment is to protect your chosen cell and ensure its survival for as long as possible.", 
		"Your first mission is to explore the different organelles of the cell. \n\n(Organelles are structures within the cell that have jobs, much like our own human organs).", 
		"Press 'x' to toggle the scan mode, or press the button in the bottom left hand corner to do so. \nScan mode allows you to click on organelles to learn about them."
		]
		text_selection = 0
		dialogue_run()

func mission1(organelle):
	$GUI/HUD.set_label_text("")
	if organelle == "":
		pass
	elif organelle == "L":
		organelles_to_learn.erase("Lysosome")
	else:
		if organelle in organelles_to_learn:
			organelles_to_learn.erase(organelle)
	
	if organelles_to_learn != []:
		label_box.text = "Try to find the next organelle using scan mode: " + str(organelles_to_learn[0]) + "\nOrganelles discovered: " + str(8 - len(organelles_to_learn)) + "/8"
	else:
		label_box.text = "You have finished discovering all of the organelles."
		yield(get_tree().create_timer(2.0), "timeout")
		$GUI/HUD/Top.hide()
		$GUI/HUD/Pause.hide()
		$GUI/HUD/MarginContainer.hide()

func dialogue_run():
	if text_selection != len(text_list):
		$GUI/HUD.set_label_text(text_list[text_selection])
		next.show()
	else:
		current_mission += 1
		call("mission" + str(current_mission), "")

func next_pressed():
	text_selection += 1
	next.hide()
	dialogue_run()

func scan_mode_toggle():
	scan_mode =! scan_mode
	if scan_mode == true:
		$GUI/HUD.popup("Scan Mode Enabled")
		$GUI/HUD/NinePatchRect/MarginContainer/TextureButton.material.set_shader_param("outline_width", 12)
	else:
		$GUI/HUD.popup("Scan Mode Disabled")
		$GUI/HUD/NinePatchRect/MarginContainer/TextureButton.material.set_shader_param("outline_width", 0)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_X:
			scan_mode_toggle()
