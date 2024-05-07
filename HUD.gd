extends Control

onready var label_box = get_node("MarginContainer/Label")

var visible_characters = 0
var lapsed = 0
var text_value = ""

func _ready():
	pass

func _physics_process(delta):
	dialogue_type(text_value, delta)

func set_label_text(text_given):
	lapsed = 0
	visible_characters = 0
	text_value = text_given

func dialogue_type(text_to_display, deltavalue): #animation effect
	if visible_characters != len(text_to_display):
		var text_to_return = ""
		lapsed += deltavalue
		visible_characters = lapsed/0.015
		
		if visible_characters > len(text_to_display):
			visible_characters = len(text_to_display)
		
		for i in visible_characters:
			text_to_return += text_to_display[i]
		
		label_box.text = text_to_return

func popup(text_given):
	$Popup/Label.text = text_given
	var tween = $Tween
	
	tween.interpolate_property($Popup, "modulate", Color(1, 1, 1, 0), 
		Color(1, 1, 1, 0.6), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	tween.interpolate_property($Popup, "modulate", Color(1, 1, 1, 0.6), 
		Color(1, 1, 1, 0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
