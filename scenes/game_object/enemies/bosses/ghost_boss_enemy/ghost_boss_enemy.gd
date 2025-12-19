extends CharacterBody2D

const EnemyManager = preload("res://scenes/manager/enemy_manager.gd")

@export var projectile_scene: PackedScene

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var attack_timer = $AttackTimer


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	attack_timer.timeout.connect(on_attack_timer_timeout)


func _process(delta: float) -> void:
	if EnemyManager.enemies_frozen:
		return
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	# Face enemy in correct direction
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign * abs(visuals.scale.x), visuals.scale.y)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()


func on_attack_timer_timeout():
	if projectile_scene == null:
		return

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	# Spawn 5 projectiles in a spread pattern
	var num_projectiles = 5
	var spread_angle = deg_to_rad(60)  # 60 degree total spread
	var base_direction = (player.global_position - global_position).normalized()
	var base_angle = base_direction.angle()

	for i in num_projectiles:
		# Calculate angle offset for each projectile
		var angle_offset = -spread_angle / 2 + (spread_angle / (num_projectiles - 1)) * i
		var projectile_angle = base_angle + angle_offset
		var projectile_direction = Vector2.RIGHT.rotated(projectile_angle)

		# Spawn projectile
		var projectile = projectile_scene.instantiate()
		projectile.direction = projectile_direction
		projectile.global_position = global_position

		# Add to foreground layer
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		if foreground_layer != null:
			foreground_layer.add_child(projectile)
