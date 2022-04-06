extends Node2D

onready var tween = $Tween
onready var nameInput = $FirstPanel/USERNAME

onready var link = "https://takbo-io-demo.vercel.app/?name=" + nameInput.text + "&score=" + str(Global.highscore)

	


func _on_SHARE_button_down():
	link = "https://takbo-io-demo.vercel.app/?name=" + nameInput.text + "&score=" + str(Global.highscore)
	$SecondPanel/shareableLink.set_bbcode("[center]" + link)
	tween.interpolate_property($FirstPanel, "position",
		Vector2(0, 0), Vector2(-500, 0), 0.5,
		10, Tween.EASE_IN)
	tween.start()
	tween.interpolate_property($SecondPanel, "position",
		Vector2(500, 0), Vector2(0, 0), 0.5,
		10, Tween.EASE_IN)
	tween.start()


func _on_COPY_button_down():
	OS.set_clipboard(link)
