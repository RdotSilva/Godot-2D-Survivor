extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
    # This will allow us to keep 3 instances of the card for developer purposes and will clear them when the scene loads
    for child in grid_container.get_children():
        child.queue_free()

    for upgrade in upgrades:
        var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
        grid_container.add_child(meta_upgrade_card_instance)

        meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_pressed():
    ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")