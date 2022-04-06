extends Node2D

var highscore = 0 setget setHighscore
var Leni = true
const filePath = "user://highscore.data"
var friendName = "Donny"
var friendScore = 143

func _ready():
	#getQueryParams()
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

func getQueryParams():
	"""
	var searchP = JavaScript.eval("window.location.search")
	if searchP:
		print("Search ", searchP)
		return searchP
	"""

