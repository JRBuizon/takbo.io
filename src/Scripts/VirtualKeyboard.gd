extends Control

onready var buttonSfx = preload("res://src/Assets/Sounds/SFX/keyboard_click_3.mp3")
var sfx: AudioStreamPlayer

const FIRST_ROW = "qwertyuiop"
const SECOND_ROW = "asdfghjkl"
const THIRD_ROW = "zxcvbnm"

func _ready():	
	for key in FIRST_ROW:
		var button = get_node("FirstRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])
		
	for key in SECOND_ROW:
		var button = get_node("SecondRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])
		
	for key in THIRD_ROW:
		var button = get_node("ThirdRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])
	
	sfx = AudioStreamPlayer.new()
	sfx.stream = buttonSfx
	sfx.volume_db = -10
	add_child(sfx)

func on_key_pressed(key: String):
	sfx.play()
	var target = get_focus_owner()
	if target is TextEdit:
		target.insert_text_at_cursor(key.to_upper())
	elif target is LineEdit:
		target.append_at_cursor(key.to_upper())

func _on_Enter_pressed():
	sfx.play()
	self.hide()
	get_focus_owner().release_focus()

func _on_Delete_pressed():
	sfx.play()
	var target = get_focus_owner()
	if target is TextEdit:
		target.text.erase(target.text.length - 1, 1)
	elif target is LineEdit:
		target.delete_char_at_cursor()

func _on_Space_pressed():
	on_key_pressed(" ")
