extends Node2D

const MUSIC_VOLUME = -25
const HARD_MODE_THRESHOLD = 250

const MUSIC_BUS = 1 # "BGM"

const Encryption = preload("res://src/Utils/encryption.gd")
var highscore = 0 setget setHighscore
var Leni = true
const filePath = "user://highscore.data"

var config = parseFriendConfig()

onready var friendName = config["name"]
var friendScore = config["score"]
var score = 0
var music_player

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = MUSIC_VOLUME
	music_player.bus = "BGM"
	add_child(music_player)
	loadHighscore()
	

func loadHighscore():
	var file = File.new()
	if not file.file_exists(filePath): return
	else:
		file.open(filePath, File.READ)
		highscore = file.get_var()
		file.close()
		
func saveHighscore():
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_var(highscore)
	file.close()
	
func setHighscore(newVal):
	highscore = newVal
	saveHighscore()

func getQueryParams(parameter):
	if OS.has_feature('JavaScript'):
		var href = JavaScript.eval("window.location.href")
		var url = JavaScript.create_object("URL", href)
		return url.searchParams.get(parameter)
	return null
	
func parseFriendConfig():
	var encrypted_hex = getQueryParams("share")
	# Error handling
	if encrypted_hex == null: 
		return { "name": null, "score": null}
		
	var data = Encryption.decrypt(encrypted_hex.percent_decode())
	
	if data == null:
		return { "name": null, "score": null}
	
	var data_object = JSON.parse(data)
	
	# What happens if the score is present but no name or vice versa?
	if data_object.error != OK:
		return { "name": null, "score": null}
		
	return data_object.result
	
func getBaseURL():
	var base_url = JavaScript.eval("window.location.origin")
	
	if base_url == null:
		return "https://takbo.io/"
	
#	For local testing only
	if base_url == "http://localhost:8060":
		return base_url + "/tmp_js_export.html"
		
	return base_url + "/"
	
func stop_music():
	music_player.stop()

func play_music(song_path: Object):
	music_player.stream = song_path
	music_player.play()

func toggle_mute():
	AudioServer.set_bus_mute(MUSIC_BUS, not AudioServer.is_bus_mute(MUSIC_BUS))
	
func is_music_muted():
	return AudioServer.is_bus_mute(MUSIC_BUS)

func track_event(event_name: String):
	var window = JavaScript.get_interface("window")
	if window != null and window.plausible != null:
		window.plausible(event_name)
