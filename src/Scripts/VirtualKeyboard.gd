extends Control

func on_key_pressed(key: String):
	var target = get_focus_owner()
	if target is TextEdit or target is LineEdit:
		target.insert_text_at_cursor(key)

# Closes the keyboard
func _on_Enter_pressed():
	self.hide()


func _on_TextureButton_pressed():
	on_key_pressed("q")
