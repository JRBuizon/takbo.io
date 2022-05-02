extends TextureProgress

func set_sprite():
	if Global.Leni:
		$Sprite.visible = true
		$Sprite2.visible = false
	elif not Global.Leni:
		$Sprite.visible = false
		$Sprite2.visible = true
