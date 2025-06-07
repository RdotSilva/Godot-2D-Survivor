extends Node

var meta_upgrades: Dictionary = {
    "meta_upgrade_currency": 0,
    "meta_upgrades": {}
}


func _ready():
    GameEvents.experience_vial_collected.connect(on_experience_collected)


func on_experience_collected(number: float):
    meta_upgrades["meta_upgrade_currency"] += number