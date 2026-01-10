extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/menus/pause_menu.tscn")
var leaderboard_scene = preload("res://scenes/ui/menus/leaderboard.tscn")

var player_has_died = false


func _ready():
	$%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	# Prevent multiple calls if signal is emitted multiple times
	if player_has_died:
		return
	
	player_has_died = true
	
	# Collect score data
	var stat_display = $StatDisplay
	var experience_manager = $ExperienceManager
	var arena_time_manager = $ArenaTimeManager
	
	# Get score values (with fallbacks in case nodes don't exist)
	var total_xp = 0.0
	var current_level = 1
	var time_elapsed = 0.0
	
	if stat_display:
		total_xp = stat_display.total_xp
	if experience_manager:
		current_level = experience_manager.current_level
	if arena_time_manager:
		time_elapsed = arena_time_manager.get_time_elapsed()
	
	# Add score to leaderboard
	LeaderboardManager.add_score("Player 1", total_xp, current_level, time_elapsed)
	
	# Show leaderboard
	var leaderboard_instance = leaderboard_scene.instantiate()
	add_child(leaderboard_instance)
	
	# Wait for leaderboard to close
	await leaderboard_instance.leaderboard_closed
	
	# Now show defeat screen
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
