extends Node

@export var spear_ability_scene: PackedScene

var base_damage = 1025
var additional_damage_percent = 1

func _ready():
    $Timer.timeout.connect(on_timer_timeout)

    GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
    var player = get_tree().get_first_node_in_group("player") as Node2D
    
    if player == null:
        return

    var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D

    if foreground == null:
        return

    var spear_instance = spear_ability_scene.instantiate() as Node2D
    foreground.add_child(spear_instance)
    spear_instance.global_position = player.global_position
    spear_instance.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if upgrade.id == "spear_damage":
        additional_damage_percent = 1 + (current_upgrades["spear_damage"]["quantity"] * 0.10)