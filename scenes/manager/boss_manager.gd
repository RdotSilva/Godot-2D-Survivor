extends Node

## Configuration for boss spawning
## Each entry should have: {boss_scene: PackedScene, spawn_time: float}
@export var boss_spawns: Array[Dictionary] = []

@export var arena_time_manager: Node
@export var enemy_manager: Node
@export var victory_screen_scene: PackedScene

var spawned_bosses: Array[Dictionary] = []
var boss_active = false


func _ready():
	GameEvents.boss_defeated.connect(on_boss_defeated)


func _process(delta: float):
	if boss_active:
		return

	var time_elapsed = arena_time_manager.get_time_elapsed()

	# Check if any boss should spawn
	for boss_spawn in boss_spawns:
		if _already_spawned(boss_spawn):
			continue

		var spawn_time = boss_spawn.get("spawn_time", 0.0)
		if time_elapsed >= spawn_time:
			_spawn_boss(boss_spawn)


func _already_spawned(boss_spawn: Dictionary) -> bool:
	return spawned_bosses.has(boss_spawn)


func _spawn_boss(boss_spawn: Dictionary):
	var boss_scene = boss_spawn.get("boss_scene") as PackedScene
	if boss_scene == null:
		return

	# Stop regular enemy spawning
	if enemy_manager != null:
		enemy_manager.stop_spawning()

	# Spawn the boss
	var boss = boss_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	if entities_layer != null:
		entities_layer.add_child(boss)
		boss.global_position = _get_boss_spawn_position()

	# Mark boss as active and track spawn
	boss_active = true
	spawned_bosses.append(boss_spawn)


func _get_boss_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	# Spawn boss in front of player (200 pixels away)
	return player.global_position + Vector2(200, 0)


func on_boss_defeated():
	boss_active = false

	# Show victory screen
	if victory_screen_scene != null:
		var victory_screen = victory_screen_scene.instantiate()
		add_child(victory_screen)
		victory_screen.set_victory()
		MetaProgression.save()
