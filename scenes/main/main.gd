extends Node

@export var end_screen_scene: PackedScene


func _ready():
    $%Player.health_component.died.connect(on_player_died)


