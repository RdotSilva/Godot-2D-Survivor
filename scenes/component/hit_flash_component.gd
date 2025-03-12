extends Node

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
    health_component.health_changed.connect(on_health_changed)


# TODO: Implement logic to emit a flash when the enemy is hit. This will require a shader.
func on_health_changed():
    pass