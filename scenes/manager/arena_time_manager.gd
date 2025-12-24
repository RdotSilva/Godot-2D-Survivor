extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

var arena_difficulty = 0
var previous_time = 0

# Shorthand for assigning a node to a variable when the node becomes ready
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta: float):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


# Get the total amount of time elapsed
func get_time_elapsed():
	return timer.wait_time - timer.time_left


# Increment the timer by the specified number of seconds (advances time)
func increment_time(seconds: float):
	if not timer.is_stopped():
		# Save the current wait_time before calling start()
		# elapsed = wait_time - time_left, so to increase elapsed by seconds,
		# we just need to decrease time_left by seconds (keeping wait_time the same)
		var original_wait_time = timer.wait_time
		var new_time_left = max(0.0, timer.time_left - seconds)
		timer.start(new_time_left)
		# Restore the original wait_time since start() resets it
		timer.wait_time = original_wait_time


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()
