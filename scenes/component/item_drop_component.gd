extends Node

@export var health_component: Node

@export_range(0, 1) var experience_vial_drop_percent: float = .5 # 50% drop rate that is configurable in UI
@export var experience_vial_drops: Array[ExperienceVialDrop] = []

@export_range(0, 1) var health_potion_drop_percent: float = .03 # 3% drop rate for health potions
@export var health_potion_scene: PackedScene

@export_range(0, 1) var bomb_drop_percent: float = .01 # 1% drop rate for bombs (rare)
@export var bomb_scene: PackedScene

@export var boss_currency_amount: int = 0

func _ready():
	(health_component as HealthComponent).died.connect(on_died)

## Function that is called whenever an entity dies
func on_died():
	if not owner is Node2D:
		return

	# If this is a boss, emit boss defeated signal and add currency
	if boss_currency_amount > 0:
		MetaProgression.add_meta_upgrade_currency(boss_currency_amount)
		GameEvents.emit_boss_defeated()
		return

	var spawn_position = (owner as Node2D).global_position
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	# Handle experience vial drops
	_try_drop_experience_vial(spawn_position, entities_layer)

	# Handle health potion drops
	_try_drop_health_potion(spawn_position, entities_layer)

	# Handle bomb drops
	_try_drop_bomb(spawn_position, entities_layer)


func _try_drop_experience_vial(spawn_position: Vector2, entities_layer: Node):
	var adjusted_drop_percent = experience_vial_drop_percent
	var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")

	if experience_gain_upgrade_count > 0:
		# Increase drop percent by 10% for each upgrade
		adjusted_drop_percent += .1

	if randf() > adjusted_drop_percent:
		return

	# Use weighted table to pick a vial variant
	if experience_vial_drops.size() == 0:
		return

	var drop_table = WeightedTable.new()
	for vial_drop in experience_vial_drops:
		drop_table.add_item(vial_drop, vial_drop.drop_weight)

	var selected_drop = drop_table.pick_item() as ExperienceVialDrop
	if selected_drop == null or selected_drop.vial_scene == null:
		return

	var vial_instance = selected_drop.vial_scene.instantiate() as Node2D
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position


func _try_drop_health_potion(spawn_position: Vector2, entities_layer: Node):
	if randf() > health_potion_drop_percent:
		return

	if health_potion_scene == null:
		return

	var potion_instance = health_potion_scene.instantiate() as Node2D
	entities_layer.add_child(potion_instance)
	potion_instance.global_position = spawn_position


func _try_drop_bomb(spawn_position: Vector2, entities_layer: Node):
	if randf() > bomb_drop_percent:
		return

	if bomb_scene == null:
		return

	var bomb_instance = bomb_scene.instantiate() as Node2D
	entities_layer.add_child(bomb_instance)
	bomb_instance.global_position = spawn_position
