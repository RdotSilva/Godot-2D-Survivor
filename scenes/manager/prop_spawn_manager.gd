extends Node

@export var spawn_area_size: Vector2 = Vector2(2000, 2000) # Size of spawnable area
@export var min_spawn_distance: float = 100.0 # Minimum distance from player
@export var max_spawn_distance: float = 800.0 # Maximum distance from player
@export var spawn_count: int = 20 # How many props to spawn initially
@export var min_object_distance: float = 40.0 # Minimum distance between objects

# Array to hold spawnable items (we'll create a custom resource for this)
@export var spawnable_items: Array[SpawnableItem] = []

# Track spawned positions to avoid overlaps
var spawned_positions: Array[Vector2] = []

func _ready() -> void:
	# Small delay to ensure player and world are ready
	await get_tree().process_frame
	spawn_initial_props()

func spawn_initial_props():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_warning("No player found for prop spawning")
		return

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		push_warning("No entities_layer found for prop spawning")
		return

	# Clear previous positions
	spawned_positions.clear()

	for i in spawn_count:
		spawn_random_prop(entities_layer, player.global_position)

func spawn_random_prop(parent_node: Node, player_position: Vector2):
	if spawnable_items.is_empty():
		return

	# Pick random item from spawnable items
	var item_data = spawnable_items.pick_random()
	if item_data == null or item_data.scene == null:
		return

	var spawn_position = get_valid_spawn_position(player_position)
	if spawn_position == Vector2.ZERO:
		return # Couldn't find valid position

	# Track this position to avoid future overlaps
	spawned_positions.append(spawn_position)

	# Instantiate the prop
	var prop_instance = item_data.scene.instantiate() as Node2D
	parent_node.add_child(prop_instance)
	prop_instance.global_position = spawn_position

func get_valid_spawn_position(player_position: Vector2) -> Vector2:
	var max_attempts = 30

	for attempt in max_attempts:
		# Generate random position within spawn area
		var random_offset = Vector2(
			randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2),
			randf_range(-spawn_area_size.y / 2, spawn_area_size.y / 2)
		)
		var potential_position = player_position + random_offset

		# Check distance constraints
		var distance_to_player = player_position.distance_to(potential_position)
		if distance_to_player < min_spawn_distance or distance_to_player > max_spawn_distance:
			continue

		# Check distance from other spawned objects
		var too_close_to_others = false
		for existing_pos in spawned_positions:
			if potential_position.distance_to(existing_pos) < min_object_distance:
				too_close_to_others = true
				break

		if too_close_to_others:
			continue

		# Check for collisions with terrain using multiple rays
		var safe_radius = 20.0  # Buffer around the spawn position
		var collision_found = false

		# Check center position
		var center_query = PhysicsRayQueryParameters2D.create(
			player_position,
			potential_position,
			1  # Terrain layer
		)
		var center_result = get_tree().root.world_2d.direct_space_state.intersect_ray(center_query)

		if not center_result.is_empty():
			collision_found = true

		# Check a few points around the spawn position to ensure clear area
		if not collision_found:
			var check_positions = [
				potential_position + Vector2(safe_radius, 0),
				potential_position + Vector2(-safe_radius, 0),
				potential_position + Vector2(0, safe_radius),
				potential_position + Vector2(0, -safe_radius)
			]

			for check_pos in check_positions:
				var check_query = PhysicsRayQueryParameters2D.create(
					player_position,
					check_pos,
					1  # Terrain layer
				)
				var check_result = get_tree().root.world_2d.direct_space_state.intersect_ray(check_query)

				if not check_result.is_empty():
					collision_found = true
					break

		if not collision_found:
			return potential_position

	return Vector2.ZERO  # Failed to find valid position

# Optional: Add method to spawn more props during gameplay
func spawn_additional_prop(player_position: Vector2):
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer:
		spawn_random_prop(entities_layer, player_position)