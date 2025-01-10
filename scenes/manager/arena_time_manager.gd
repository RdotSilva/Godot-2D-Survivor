extends Node

@export var victory_screen_scene: PackedScene

# Shorthand for assigning a node to a variable when the node becomes ready
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


# Get the total amount of time elapsed
func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var victory_screen_instance = victory_screen_scene.instantiate()
	add_child(victory_screen_instance)