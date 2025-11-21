extends Area2D

var speed = 150.0
var direction = Vector2.RIGHT
var lifetime = 5.0
var damage = 2


func _ready():
	# Connect to area collision (for player's CollisionArea2D)
	area_entered.connect(on_area_entered)

	# Auto-destroy after lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)


func _process(delta: float):
	# Move in the set direction
	global_position += direction * speed * delta


func on_area_entered(area: Area2D):
	# Check if this is the player's collision area
	var owner_node = area.get_parent()
	if owner_node != null and owner_node.is_in_group("player"):
		var player = owner_node as Node
		if player != null and player.has_method("take_damage"):
			player.take_damage(damage)
		queue_free()
