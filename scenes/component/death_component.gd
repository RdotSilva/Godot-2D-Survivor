extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
	# This will keep the particle in sync with the enemy visual
	$GPUParticles2D.texture = sprite.texture
	
	health_component.died.connect(on_died)

func on_died():
	if owner == null || not owner is Node2D:
		return

	var spawn_position = owner.global_position

	# Get reference before we remove ourselves otherwise it won't be available
	var entities = get_tree().get_first_node_in_group("entities_layer")

	get_parent().remove_child(self)

	entities.add_child(self)

	global_position = spawn_position

	$AnimationPlayer.play("default")
	$HitRandomAudioPlayerComponent.play_random()
