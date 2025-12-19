extends CharacterBody2D

const EnemyManager = preload("res://scenes/manager/enemy_manager.gd")

@export var projectile_scene: PackedScene

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var attack_timer = $AttackTimer

var is_moving = false


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	attack_timer.timeout.connect(on_attack_timer_timeout)


func _process(delta: float) -> void:
	if EnemyManager.enemies_frozen:
		return
	
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()

	# Always apply the movement even if the movement or velocity stops
	velocity_component.move(self)

	# Face enemy in correct location
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()


func on_attack_timer_timeout():
	# Only shoot when stopped
	if is_moving:
		return

	if projectile_scene == null:
		return

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	# Calculate direction to player
	var direction = (player.global_position - global_position).normalized()

	# Spawn projectile
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	projectile.global_position = global_position

	# Add to foreground layer
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer != null:
		foreground_layer.add_child(projectile)