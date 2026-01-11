extends Node
const SAVE_FILE_PATH = "user://leaderboard.save"
const MAX_LEADERBOARD_ENTRIES = 10

var leaderboard_data: Array[Dictionary] = []


func _ready():
	load_save_file()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	else:
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		leaderboard_data = file.get_var()
		# Ensure we have an array
		if leaderboard_data == null:
			leaderboard_data = []
