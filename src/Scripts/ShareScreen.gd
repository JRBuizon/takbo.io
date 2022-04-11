extends Node2D

const Encryption = preload("res://src/Utils/encryption.gd")
onready var tween = $Tween
onready var nameInput = $FirstPanel/LineEdit
var amplitude = 3
var time = 0

onready var link = Global.getBaseURL()

func _ready():
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$FirstPanel/Label2.text = str(Global.score)
	
func _process(delta):
	time += delta * 2
	$TakboLogo.position = Vector2(240, amplitude * sin(time) + 163)

func _on_SHARE_button_down():
#	Need to create the new link with AES encryption
	var body = {
		"name": nameInput.text,
		"score": str(Global.score),
	}
	
	var data = JSON.print(body)
	
#	Converts the encrypted data to base64
	var encrypted_base_64 = Encryption.encrypt(data)
	
	link = Global.getBaseURL() + "?share=" + encrypted_base_64.percent_encode()
	
	tween.interpolate_property($SecondPanel, "position",
		Vector2(500, 0), Vector2(-500, 0), 2,
		10, Tween.EASE_OUT_IN)
	tween.start()
	
	if OS.get_name() == "iOS":
		var alert = JavaScript.eval("window.prompt(" + link + ");")
		
	else:
		OS.set_clipboard(link)


func _on_EXIT_button_down():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$Timer.start()
	

func _on_Timer_timeout():
	get_tree().change_scene("res://src/Scenes/MainMenu.tscn")


func _on_LineEdit_focus_entered():
	# Prompts the user to input their username
	var input_value = JavaScript.eval("window.prompt('Enter name')")
	if input_value != null:
		nameInput.text = input_value
	# Only needs to release focus if game is running on a mobile device	
	if OS.has_touchscreen_ui_hint():
		nameInput.release_focus()
