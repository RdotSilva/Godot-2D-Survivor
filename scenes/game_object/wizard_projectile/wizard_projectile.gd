extends Area2D

var speed = 75.0 # Slower than boss projectile
var direction = Vector2.RIGHT
var lifetime = 4.0
var damage = 1

# Homing behavior
var homing_strength = 2.0 # How aggressively it homes toward player
var is_homing = true


func _ready():
	# Connect to area collision (for player's CollisionArea2D)
	area_entered.connect(on_area_entered)

	# Auto-destroy after lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)


func _process(delta: float):
	# Homing behavior - gradually adjust direction toward player
	if is_homing:
		var player = get_tree().get_first_node_in_group("player") as Node2D
		if player != null:
			var target_direction = (player.global_position - global_position).normalized()
			# Smoothly interpolate between current direction and target
			direction = direction.lerp(target_direction, homing_strength * delta).normalized()

	# Move in the current direction
	global_position += direction * speed * delta

	# Rotate sprite to face movement direction (optional visual)
	rotation = direction.angle()


func on_area_entered(area: Area2D):
	# Check if this is the player's collision area
	var owner_node = area.get_parent()
	if owner_node != null and owner_node.is_in_group("player"):
		var player = owner_node as Node
		if player != null and player.has_method("take_damage"):
			player.take_damage(damage)
		queue_free()
