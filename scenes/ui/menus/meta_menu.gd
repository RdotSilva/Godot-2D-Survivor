extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer
@onready var back_button = $%BackButton
@onready var respec_button = $%RespecButton

var meta_upgrade_card_scene = preload("res://scenes/ui/cards/meta_upgrade_card.tscn")


func _ready():
	back_button.pressed.connect(on_back_pressed)
	respec_button.pressed.connect(on_respec_pressed)

	# This will allow us to keep 3 instances of the card for developer purposes and will clear them when the scene loads
	for child in grid_container.get_children():
		child.queue_free()

	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)

		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
	
	# Update respec button state initially
	update_respec_button_state()


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/menus/main_menu.tscn")


func on_respec_pressed():
	# Check if player has any upgrades to refund
	if MetaProgression.save_data["meta_upgrades"].is_empty():
		return

	# Refund all upgrades
	MetaProgression.refund_all_upgrades(upgrades)

	# Update all upgrade cards to reflect the changes
	get_tree().call_group("meta_upgrade_card", "update_progress")
	
	# Update respec button state after refunding
	update_respec_button_state()


func update_respec_button_state():
	# Disable respec button if no upgrades have been purchased
	var has_upgrades = !MetaProgression.save_data["meta_upgrades"].is_empty()
	respec_button.disabled = !has_upgrades
