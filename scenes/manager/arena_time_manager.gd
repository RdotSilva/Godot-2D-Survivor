extends Node

# Shorthand for assigning a node to a variable when the node becomes ready
@onready var timer = $Timer


# Get the total amount of time elapsed
func get_time_elapsed():
	return timer.wait_time - timer.time_left