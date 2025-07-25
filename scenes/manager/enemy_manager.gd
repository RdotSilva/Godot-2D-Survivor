extends Node

# Viewport is 640 and half of that is 320 (+10 for buffer)
const SPAWN_RADIUS = 370

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)

	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return Vector2.ZERO

	
	var spawn_position = Vector2.ZERO

	# Get a random direction and rotate
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4:
		# Take player position with the direction
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		# Additional offset to ensure monsters don't spawn in the wall
		var additional_check_offset = random_direction * 20

		# Raycast collisions
		# TODO: Look into additional_check_offset to see if its needed (confirm within code base)
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


# TODO: Check this to ensure enemies are not spawned outside of the walls
# Spawn the enemy outside the view of the player
func on_timer_timeout():
	# Timer restarted after the potential timer difficulty increase happens
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D

	# This should always exist
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	# Add node to scene tree (under which parent)
	entities_layer.add_child(enemy)

	# Assign global position for the enemy
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	# 5 seconds per difficulty increase
	var time_off = (.1 / 12) * arena_difficulty

	# Cap the max spawn rate to avoid spawning too fast
	time_off = min(time_off, .7)

	timer.wait_time = base_spawn_time - time_off

	# 30 seconds into the game we will start spawning the wizard with a higher weight and then later we spawn bats
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 15)
	elif arena_difficulty == 18:
		enemy_table.add_item(bat_enemy_scene, 8)