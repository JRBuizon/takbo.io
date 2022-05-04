extends TextureProgress

func set_sprite():
	if Global.Character == Global.Leni:
		$Sprite.visible = true
		$Sprite2.visible = false
		$Sprite3.visible = false
	elif Global.Character == Global.Kiko:
		$Sprite.visible = false
		$Sprite2.visible = true
		$Sprite3.visible = false
	elif Global.Character == Global.Gab:
		$Sprite.visible = false
		$Sprite2.visible = false
		$Sprite3.visible = true
