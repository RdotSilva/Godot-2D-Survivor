extends Node

## Debug Manager - Handles spawning items and enemies for debugging
## Designed to be extensible - add new spawn types as needed

# Item scenes
@export var experience_vial_scene: PackedScene
@export var experience_vial_rare_scene: PackedScene
@export var health_potion_scene: PackedScene
@export var bomb_scene: PackedScene

# Enemy scenes
@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene


func _ready():
	# Debug manager is ready
	pass


## Get the spawn position (offset from player to avoid immediate pickup/damage)
## Spawns items/enemies at a fixed offset from the player
## Can be extended later to use mouse position or other logic
func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		# Fallback to center if player doesn't exist
		return Vector2(320, 180)  # Center of 640x360 viewport
	
	# Spawn at offset from player (100 pixels up and right)
	# This prevents immediate pickup/damage when debugging
	var spawn_offset = Vector2(100, -100)
	return player.global_position + spawn_offset


## Get the entities layer where we spawn things
func get_entities_layer() -> Node:
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if entities_layer == null:
		push_error("DebugManager: entities_layer not found!")
		return null
	
	return entities_layer


## Spawn an item at the player's position
func spawn_item(item_scene: PackedScene) -> void:
	if item_scene == null:
		push_error("DebugManager: Cannot spawn - item_scene is null")
		return
	
	var entities_layer = get_entities_layer()
	if entities_layer == null:
		return
	
	var item_instance = item_scene.instantiate() as Node2D
	if item_instance == null:
		push_error("DebugManager: Failed to instantiate item scene")
		return
	
	entities_layer.add_child(item_instance)
	item_instance.global_position = get_spawn_position()
	
	print("DebugManager: Spawned item at ", item_instance.global_position)


## Spawn an enemy at the player's position
func spawn_enemy(enemy_scene: PackedScene) -> void:
	if enemy_scene == null:
		push_error("DebugManager: Cannot spawn - enemy_scene is null")
		return
	
	var entities_layer = get_entities_layer()
	if entities_layer == null:
		return
	
	var enemy_instance = enemy_scene.instantiate() as Node2D
	if enemy_instance == null:
		push_error("DebugManager: Failed to instantiate enemy scene")
		return
	
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	
	print("DebugManager: Spawned enemy at ", enemy_instance.global_position)


func spawn_experience_vial() -> void:
	spawn_item(experience_vial_scene)


func spawn_experience_vial_rare() -> void:
	spawn_item(experience_vial_rare_scene)


func spawn_health_potion() -> void:
	spawn_item(health_potion_scene)


func spawn_bomb() -> void:
	spawn_item(bomb_scene)


func spawn_basic_enemy() -> void:
	spawn_enemy(basic_enemy_scene)


func spawn_wizard_enemy() -> void:
	spawn_enemy(wizard_enemy_scene)


func spawn_bat_enemy() -> void:
	spawn_enemy(bat_enemy_scene)

