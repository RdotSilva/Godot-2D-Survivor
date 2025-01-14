extends Node

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

var arena_difficulty = 0
var previous_time = 0

# Shorthand for assigning a node to a variable when the node becomes ready
@onready var timer = $Timer


func _ready():
	previous_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)


# Get the total amount of time elapsed
func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)