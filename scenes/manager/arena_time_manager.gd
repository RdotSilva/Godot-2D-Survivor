extends Node

# Shorthand for assigning a node to a variable when the node becomes ready
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Get the total amount of time elapsed
func get_time_elapsed():
	return timer.wait_time - timer.time_left