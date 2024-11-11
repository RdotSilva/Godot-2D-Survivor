extends Node

# Viewport is 640 and half of that is 320 (+10 for buffer)
const SPAWN_RADIUS = 330

@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	# TODO: Add on_timer_timeout function
