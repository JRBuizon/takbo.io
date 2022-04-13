extends Node2D

const Encryption = preload("res://src/Utils/encryption.gd")
onready var tween = $Tween
onready var nameInput = $FirstPanel/LineEdit
var amplitude = 3
var time = 0

onready var link = Global.getBaseURL()
onready var buttonSfx = preload("res://src/Assets/Sounds/SFX/buttonv1.mp3")
var sfx: AudioStreamPlayer

func _ready():
	sfx = AudioStreamPlayer.new()
	sfx.volume_db = -10
	add_child(sfx)
	sfx.stream = buttonSfx
	
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$FirstPanel/Label2.text = str(Global.score)
	nameInput.text = "Default"
	
func _process(delta):
	time += delta * 2
	$TakboLogo.position = Vector2(240, amplitude * sin(time) + 163)

func _on_SHARE_pressed():
	sfx.play()	
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
	
	Global.track_event("CopyLink")
	OS.set_clipboard(link)


func _on_EXIT_button_down():
	sfx.play()
	Global.stop_music()
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$Timer.start()
	

func _on_Timer_timeout():
	get_tree().change_scene("res://src/Scenes/MainMenu.tscn")
