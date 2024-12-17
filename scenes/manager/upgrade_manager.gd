extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade

	if chosen_upgrade == null:
		return

	var has_upgrade = current_upgrades.has(chosen_upgrade.id)

	# Check if we already have the upgrade and can increment or if we need to add it for the first time
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
