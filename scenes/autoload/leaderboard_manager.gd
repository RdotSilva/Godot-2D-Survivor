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


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(leaderboard_data)



func add_score(name: String, score: float, level: int, time_elapsed: float) -> bool:
	var new_entry = {
		"name": name,
		"score": score,
		"level": level,
		"time_elapsed": time_elapsed
	}
	
	# Add the new entry
	leaderboard_data.append(new_entry)
	
	# Sort by score (highest first)
	leaderboard_data.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# Keep only top 10
	var made_top_10 = leaderboard_data.size() <= MAX_LEADERBOARD_ENTRIES or leaderboard_data.find(new_entry) < MAX_LEADERBOARD_ENTRIES
	leaderboard_data = leaderboard_data.slice(0, min(leaderboard_data.size(), MAX_LEADERBOARD_ENTRIES))
	
	save()
	
	return made_top_10


func get_top_scores() -> Array[Dictionary]:
	return leaderboard_data.duplicate()


func would_make_top_10(score: float) -> bool:
	if leaderboard_data.size() < MAX_LEADERBOARD_ENTRIES:
		return true
	
	# Check if score is higher than the lowest score in top 10
	if leaderboard_data.size() > 0:
		var lowest_score = leaderboard_data[-1]["score"]
		return score > lowest_score
	
	return true


func clear_leaderboard():
	leaderboard_data.clear()
	save()
