extends Node2D

# This is the furthest away the spear can be from the player
const MAX_RADIUS = 20

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
    # Randomize the rotation
    base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    # A tween is a way to define an animation
    var tween = create_tween()
    tween.tween_method(tween_method, 0.0, 2.0, 3)
    tween.tween_callback(queue_free)


func tween_method(rotations: float):
    var percent = (rotations / 2)
    var current_radius = percent * MAX_RADIUS
    var current_direction = base_rotation.rotated(rotations * TAU)

    # Positioning logic for the spear

    var player = get_tree().get_first_node_in_group("player")
    if player == null:
       return

    # Offset the spear positioning
    global_position = player.global_position + (current_direction * current_radius)