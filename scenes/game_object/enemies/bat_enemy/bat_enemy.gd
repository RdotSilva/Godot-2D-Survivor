extends CharacterBody2D

const EnemyManager = preload("res://scenes/manager/enemy_manager.gd")

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)


func _process(delta: float) -> void:
	if EnemyManager.enemies_frozen:
		return
	
	velocity_component.accelerate_to_player()
	
	# Always apply the movement even if the movement or velocity stops
	velocity_component.move(self)

	# Face enemy in correct location
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()