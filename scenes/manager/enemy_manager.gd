extends Node

# Viewport is 640 and the radius should be set to half of that size
const SPAWN_RADIUS = 320

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var number_to_spawn = 1


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)

	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


## Validates if a spawn position is safe (no walls/obstacles)
## Checks center position and 4 cardinal directions around it
func is_spawn_position_valid(player_position: Vector2, spawn_position: Vector2) -> bool:
	var safe_radius = 20.0 # Buffer around the spawn position

	# Check center position - raycast from player to spawn point
	var center_query = PhysicsRayQueryParameters2D.create(
		player_position,
		spawn_position,
		1 # Terrain layer
	)
	var center_result = get_tree().root.world_2d.direct_space_state.intersect_ray(center_query)

	if not center_result.is_empty():
		return false

	# Check 4 points around the spawn position to ensure clear area
	var check_positions = [
		spawn_position + Vector2(safe_radius, 0),
		spawn_position + Vector2(-safe_radius, 0),
		spawn_position + Vector2(0, safe_radius),
		spawn_position + Vector2(0, -safe_radius)
	]

	for check_pos in check_positions:
		var check_query = PhysicsRayQueryParameters2D.create(
			player_position,
			check_pos,
			1 # Terrain layer
		)
		var check_result = get_tree().root.world_2d.direct_space_state.intersect_ray(check_query)

		if not check_result.is_empty():
			return false

	return true


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return Vector2.ZERO


	var spawn_position = Vector2.ZERO

	# Get a random direction and rotate
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

	# Increased attempts to ensure we find valid positions
	for i in 12:
		# Take player position with the direction
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		# Validate spawn position with comprehensive checks
		if is_spawn_position_valid(player.global_position, spawn_position):
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(30))

	return spawn_position


func stop_spawning():
	timer.stop()


func resume_spawning():
	timer.start()


# TODO: Check this to ensure enemies are not spawned outside of the walls
# Spawn the enemy outside the view of the player
func on_timer_timeout():
	# Timer restarted after the potential timer difficulty increase happens
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	for i in number_to_spawn:
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

	# 30 second interval - Increase the number of enemies to spawn
	if (arena_difficulty % 6) == 0:
		number_to_spawn += 1
		number_to_spawn = min(number_to_spawn, 5) # Cap at 5 enemies per wave