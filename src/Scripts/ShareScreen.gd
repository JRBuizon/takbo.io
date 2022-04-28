extends Node2D

const Encryption = preload("res://src/Utils/encryption.gd")
onready var tween = $Tween
onready var nameInput = $FirstPanel/LineEdit
onready var keyboard = $VirtualKeyboard
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
	nameInput.text = "User"
	
func _process(delta):
	time += delta * 2
	$TakboLogo.position = Vector2(240, amplitude * sin(time) + 163)

func _on_SHARE_pressed():
	sfx.play()	
	
	tween.interpolate_property($SecondPanel, "position",
	Vector2(500, 0), Vector2(-500, 0), 2,
	10, Tween.EASE_OUT_IN)
	tween.start()
	
#	Need to create the new link with AES encryption
	var body = {
		"name": nameInput.text,
		"score": str(Global.score),
	}
	
	var data = JSON.print(body)
	
#	Converts the encrypted data to base64
	var encrypted_base_64 = Encryption.encrypt(data)
	
	link = Global.getBaseURL() + "?share=" + encrypted_base_64.percent_encode()
	
	var message = "Nakascore ng %s si %s sa huli niyang takbo! Subukan siyang talunin sa Takbo.io #TakboLeniKiko #LeniKikoAllTheWay\n\n"
	
	var formatted_message = message % [body["score"], body["name"]]
	
	var window = JavaScript.get_interface("window");
	
	Global.track_event("CopyLink")
	
	# Fallback to clipboard copy
	OS.set_clipboard(formatted_message + link);

	# Attempt to bring up the share menu
	var script_message = """
	  navigator.share({
		"url": "%s",
		"text": `%s`,
		"title": "Takbo.io | Beat my score!"
	  })
	""" % [link, formatted_message]
	
	if window.navigator.canShare != null and JavaScript.eval("navigator.canShare(%s)" % script_message):
		
		JavaScript.eval(script_message)


func _on_EXIT_button_down():
	sfx.play()
	Global.stop_music()
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$Timer.start()
	

func _on_Timer_timeout():
	get_tree().change_scene("res://src/Scenes/MainMenu.tscn")


func _on_LineEdit_focus_entered():
	# TODO Can also check if the device supports the virtual keyboard.
	if OS.has_touchscreen_ui_hint():
		keyboard.show()
