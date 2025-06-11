extends Node

@export var spear_ability_scene: PackedScene

var base_damage = 1025
var additional_damage_percent = 1

func _ready():
    GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if upgrade.id == "spear_damage":
        additional_damage_percent = 1 + (current_upgrades["spear_damage"]["quantity"] * 0.10)