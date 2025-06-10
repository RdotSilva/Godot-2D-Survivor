extends Node2D

# This is the furthest away the axe can be from the player
const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
    # Randomize the rotation
    base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    # A tween is a way to define an animation
    var tween = create_tween()
    tween.tween_method(tween_method, 0.0, 2.0, 3)
    tween.tween_callback(queue_free)


