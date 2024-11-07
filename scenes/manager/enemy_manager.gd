extends Node

# Viewport is 640 and half of that is 320 (+10 for buffer)
const SPAWN_RADIUS = 330

# Expose the variable in the inspector
@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)

# Spawn the enemy outside the view of the player
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)


