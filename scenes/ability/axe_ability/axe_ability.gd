extends Node2D

# This is the furthest away the axe can be from the player
const MAX_RADIUS = 100

func tween_method(rotations: float):
    var percent = (rotations / 2)
    var current_radius = percent * MAX_RADIUS
    var current_direction = Vector2.RIGHT.rotated(rotations * TAU)

    # Positioning logic for the axe
    var root_position = Vector2.ZERO
    var player = get_tree().get_first_node_in_group("player")
    if player == null:
        root_position = global_position
    else:
        root_position = player.global_position

    global_position = root_position + (current_direction * current_radius)