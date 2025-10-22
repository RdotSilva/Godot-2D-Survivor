extends Node

# Shorthand for pointing to user directory
const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	else:
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func delete_save():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
	
	# Reset save data to defaults
	save_data = {
		"meta_upgrade_currency": 0,
		"meta_upgrades": {}
	}


func add_meta_upgrade_currency(amount: int):
	save_data["meta_upgrade_currency"] += amount
	save()


func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0,
		}

	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func get_upgrade_count(upgrade_id: String):
	if MetaProgression.save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func refund_all_upgrades(upgrades: Array[MetaUpgrade]):
	# Calculate total refund amount by iterating through all purchased upgrades
	var total_refund = 0

	for upgrade in upgrades:
		if save_data["meta_upgrades"].has(upgrade.id):
			var quantity = save_data["meta_upgrades"][upgrade.id]["quantity"]
			total_refund += upgrade.experience_cost * quantity

	# Reset all meta upgrades to empty
	save_data["meta_upgrades"] = {}

	# Add the refunded experience back to currency
	save_data["meta_upgrade_currency"] += total_refund

	save()

	return total_refund


func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
	save()
