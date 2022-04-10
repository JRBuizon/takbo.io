extends Node2D

const Encryption = preload("res://src/Utils/encryption.gd")
var highscore = 0 setget setHighscore
var Leni = true
const filePath = "user://highscore.data"

var config = parseFriendConfig()

onready var friendName = config["name"]
var friendScore = config["score"]
var score = 0

func _ready():
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
	var encrypted_base_64 = getQueryParams("share")
	# Error handling
	if encrypted_base_64 == null: 
		return { "name": null, "score": null}
		
	encrypted_base_64 = encrypted_base_64.percent_decode()
	var data = Encryption.decrypt(encrypted_base_64)
	var data_object = JSON.parse(data)
	
	# What happens if the score is present but no name or vice versa?
	if data_object.error != OK:
		return { "name": null, "score": null}
		
	return data_object.result
	
