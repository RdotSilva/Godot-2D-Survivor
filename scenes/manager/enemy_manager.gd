extends Node

# Viewport is 640 and half of that is 320 (+10 for buffer)
const SPAWN_RADIUS = 330

@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)

# Spawn the enemy outside the view of the player
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	# Get a random direction and rotate
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	# Take player position with the direction
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

	# Create the node
	var enemy = basic_enemy_scene.instantiate() as Node2D

	# Add node to scene tree (under which parent)
	get_parent().add_child(enemy)

	# Assign global position for the enemy
	enemy.global_position = spawn_position
