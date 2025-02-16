extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO




func accelerate_in_direction(direction: Vector2):
    var desired_velocity = direction * max_speed

    velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


