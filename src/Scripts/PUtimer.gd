extends TextureProgress

func set_sprite(PUname):
	if Global.Leni and PUname == "Glide":
		$Sprite.visible = true
		$Sprite2.visible = false
		$Sprite3.visible = false
	elif not Global.Leni and PUname == "Glide":
		$Sprite.visible = false
		$Sprite2.visible = true
		$Sprite3.visible = false
	elif PUname == "Bike":
		$Sprite.visible = false
		$Sprite2.visible = false
		$Sprite3.visible = true
