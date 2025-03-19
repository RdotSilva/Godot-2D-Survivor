extends Node

const MAX_RANGE = 150

# Make max range configuratble in UI
# @export var max_range: float

@export var sword_ability: PackedScene

# Default damage
var base_damage = 5
var additional_damage_percent = 1
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = $Timer.wait_time
	
	# get_node("Timer")

	$Timer.timeout.connect(on_timer_timeout)

	# act on the game event to connect to the ability upgrade
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")

	# Filter out all enemies that are farther than 150 pixels from the player
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)

	if enemies.size() == 0:
		return

	# Sort enemies by distance
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)

		return a_distance < b_distance
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility

	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	foreground_layer.add_child(sword_instance)

	# Assign the damage
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent

	# The first enemy in the sorted array will be where the sword spawns
	sword_instance.global_position = enemies[0].global_position

	# Randomize the rotation of the vector from 0 - 360 degrees
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# Take enemy position and point at enemy position from the sword position
	var enemy_direction = enemies[0].global_position - sword_instance.global_position

	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return

	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	
	# Reduce timer for sword ability
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)

	# Restart the timer
	$Timer.start()