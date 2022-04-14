extends Control

const FIRST_ROW = "qwertyuiop"
const SECOND_ROW = "asdfghjkl"
const THIRD_ROW = "zxcvbnm"

func _ready():
	for key in FIRST_ROW:
		var button = get_node("FirstRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])
		
	for key in SECOND_ROW:
		var button = get_node("FirstRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])
		
	for key in THIRD_ROW:
		var button = get_node("FirstRow/" + key)
		button.connect("pressed", self, "on_key_pressed", [key])

func on_key_pressed(key: String):
	var target = get_focus_owner()
	if target is TextEdit:
		target.insert_text_at_cursor(key)
	elif target is LineEdit:
		target.append_at_cursor(key)

func _on_Enter_pressed():
	self.hide()
	
func _on_Delete_pressed():
	var target = get_focus_owner()
	if target is TextEdit:
		target.text.erase(target.text.length - 1, 1)
	elif target is LineEdit:
		target.delete_char_at_cursor()
		
func _on_Space_pressed():
	on_key_pressed(" ")
