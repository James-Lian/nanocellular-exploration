extends CanvasLayer

signal panel_active
signal cytoplasm_learned

var panel_activ_pos_x
var panel_active = false
var current_panel = ""

onready var close = get_node("Info_Panel/MarginContainer/VBoxContainer/Close")

onready var title = get_node("Info_Panel/MarginContainer/VBoxContainer/MarginContainer/Title")
onready var texturerect = get_node("Info_Panel/MarginContainer/VBoxContainer/TextureRect")
onready var label = get_node("Info_Panel/MarginContainer/VBoxContainer/Label")

func _ready():
	$Info_Panel.show()
	_resize()
	var _window_change = get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")

	$Info_Panel.rect_position.x = OS.get_window_size().x #moves panel out of view
	
	self.connect("panel_active", get_parent(), "panel_activated")
	self.connect("cytoplasm_learned", get_parent(), "start_mission_dialogue")

func _resize():
	#readjust Info_Panel size
	$Info_Panel.rect_size.y = OS.get_window_size().y * 2
	$Info_Panel.rect_position.y = -((OS.get_window_size().y * 2))/4
	$Info_Panel.rect_size.x = OS.get_window_size().x * 0.2 * 2

	if panel_active:
		$Info_Panel.rect_position.x = panel_activ_pos_x
	elif !panel_active:
		$Info_Panel.rect_position.x = OS.get_window_size().x #repositions panel out of view
	#FIX HIDING PANEL WHEN WINDOW IS READJUSTED

	panel_activ_pos_x = OS.get_window_size().x * 0.8 #when the panel is activated, this is where it will go

func _on_viewport_size_changed():
	_resize()

func info_panel(click_organelle):
	panel_active = true
	
	#interpolate_property(_node-name_, _property_, _start-value_, _end-value_, _duration_, _trans_, _ease_)
	var panel_tween = get_node("Tween")
	panel_tween.interpolate_property($Info_Panel, "rect_position:x", OS.get_window_size().x, 
		panel_activ_pos_x, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	panel_tween.start()
	
	emit_signal("panel_active", OS.get_window_size().x * 0.2, panel_active)
	call(click_organelle)
	current_panel = click_organelle

func close_info_panel():
	panel_active = false
	
	emit_signal("panel_active", 0, panel_active)
	
	#repositions Info_Panel out of view
	$Info_Panel.rect_position.x = OS.get_window_size().x
	
	if current_panel == "Cytoplasm":
		emit_signal("cytoplasm_learned")

func Cytoplasm():
	title.text = "Cytoplasm"
	label.text = "The cytoplasm is a watery fluid that fills up the cell and stores all of its contents. It allows materials to be transported around the cell, and stores any waste until it can be disposed of. \n\nYou are currently traveling inside the cell's cytoplasm."
	texturerect.rect_min_size.y = 10
	texturerect.texture = null

func Membrane():
	title.text = "Cell Membrane"
	label.text = "The cell membrane is a biological membrane made of lipids and proteins that completely encases the cell. \nThe cell membrane controls what goes in the cell and what goes out. Thanks to this, the cell membrane regulates the absorption of nutrients and materials, and the disposal of waste."
	texturerect.rect_min_size.y = 10
	texturerect.texture = null

func Golgi_Apparatus():
	reset_texturerect()
	title.text = "Golgi Apparatus"
	label.text = "The golgi apparatus helps to package and process both proteins and liquid molecules. It receives these materials from the Endoplasmic Reticulum. \nIt then puts proteins into packages called vesicles, which are then carried around the cell to destinations where needed."
	texturerect.texture = load("res://Thumbs/Golgi_Apparatus_Thumb.png")

func Endoplasmic_Reticulum():
	reset_texturerect()
	title.text = "Endoplasmic Reticulum"
	label.text = "The endoplasmic reticulum is a network of folded membranes throughout the cell. These folded membranes form transport networks that extend from the membrane of the nucleus and transport materials throughout the cell. \nIt also receives proteins made by ribosomes and adds sugars and phosphates. These processed materials are then ferried around until they arrive at their destination."
	texturerect.texture = load("res://Thumbs/Endoplasmic_Reticulum_Thumb.png")

func Nucleus():
	reset_texturerect()
	title.text = "Nucleus"
	label.text = "The nucleus is a membrane-bound organelle that houses the cell's DNA. The DNA is your cell’s instructions for creating proteins. \nThanks to this, the nucleus directs all activities in the cell based on instructions written in the DNA. The proteins created play a direct role in maintaining the life of the cell.\nThe nucleus is also studded with pores where materials can enter and exit."
	texturerect.texture = load("res://Thumbs/Nucleus_Thumb.png")

func Microfilaments():
	reset_texturerect()
	title.text = "Cytoskeleton"
	label.text = "Microtubules and microfilaments make up the exoskeleton of the cell, loosely containing organelles and maintaining the shape of the cell. They are also involved in the movement of the cell. \nMicrofilaments, sometimes known as actin filaments, provide great transportation “tracks” for vesicles to travel throughout the cell. They have “motor proteins” that connect to the vesicle and migrate along the filaments."
	texturerect.texture = load("res://Thumbs/Microfilaments_Thumb.png")

func Ribosomes():
	reset_texturerect()
	title.text = "Ribosome"
	label.text = "Ribosomes are tiny “chef” molecules that assemble proteins based on the instructions from the nucleus. \nThe nucleus creates copies of its DNA called mRNA, which is released from the nucleus through tiny pores. \nThe ribosome reads the genetic information stored on the mRNA molecule and assembles proteins based on what it reads by linking amino acids together. These proteins are needed for almost all aspects of the cell’s life."
	texturerect.texture = load("res://Thumbs/Ribosome.png")

func Mitochondria():
	reset_texturerect()
	title.text = "Mitochondria"
	label.text = "Mitochondria are membrane-bound organelles who produce chemical energy for the cell to function. The process for the creation of this energy is called cellular respiration, and the process itself is similar to a combustion reaction. \nA mitochondrion releases energy in the form of ATP (adenosine triphosphate)."
	texturerect.texture = load("res://Thumbs/Mitochondria.png")

func Lysosome1():
	reset_texturerect()
	title.text = "Lysosome"
	label.text = "The lysosomes are known as the “suicide bags” of the cell, mainly because they are membrane-bound organelles found within the cell containing lytic enzymes, capable of digesting the cell from the inside out. \nThey roam the cytoplasm in search of leftover molecules. When they find some, they break down the leftover molecules into smaller molecules to be reused again. Lysosomes are also used to defend against invading organisms."
	texturerect.texture = load("res://Lysosome.png")

func reset_texturerect():
	texturerect.rect_min_size.y = 200
