extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


