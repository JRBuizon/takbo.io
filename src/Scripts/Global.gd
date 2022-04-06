extends Node2D

var highscore = 0 setget setHighscore
var Leni = true
const filePath = "user://highscore.data"
onready var friendName = getQueryParams("name")
var friendScore = getQueryParams("score")

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
	

