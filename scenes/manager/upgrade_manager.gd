extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

# Queue system for handling multiple level-ups
var pending_level_ups: Array[int] = []
var is_showing_upgrade_screen: bool = false

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var anvil_upgrade = preload("res://resources/upgrades/anvil.tres")
var anvil_upgrade_count = preload("res://resources/upgrades/anvil_count.tres")
var upgrade_shield = preload("res://resources/upgrades/shield.tres")


func _ready():
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(anvil_upgrade, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	upgrade_pool.add_item(upgrade_shield, 10)

	experience_manager.level_up.connect(on_level_up)

func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)

	# Check if we already have the upgrade and can increment or if we need to add it for the first time
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
			
	update_upgrade_pool(upgrade)

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


# TODO: Double check this logic and make sure this works with all upgrades
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	elif chosen_upgrade.id == anvil_upgrade.id:
		upgrade_pool.add_item(anvil_upgrade_count, 5)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []

	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break

		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)

		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	# Don't process next level-up here - wait for screen to fully close
	# The screen_closed signal will trigger process_next_level_up()


func on_level_up(current_level: int):
	# Add this level-up to the queue
	pending_level_ups.append(current_level)
	
	# If no upgrade screen is currently showing, show the first one
	if not is_showing_upgrade_screen:
		process_next_level_up()


func process_next_level_up():
	# If there are no pending level-ups, we're done
	if pending_level_ups.is_empty():
		is_showing_upgrade_screen = false
		return
	
	# Mark that we're showing an upgrade screen
	is_showing_upgrade_screen = true
	
	# Get the next level-up from the queue
	var current_level = pending_level_ups.pop_front()
	
	# Create and show the upgrade screen
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	
	# Connect signals
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	# When screen fully closes, process the next level-up if there are any
	upgrade_screen_instance.screen_closed.connect(_on_screen_closed)


func _on_screen_closed():
	# Screen has fully closed, now process the next level-up in the queue
	process_next_level_up()
