extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
    # This will keep the particle in sync with the enemy visual
    $GPUParticles2D.texture = sprite.text
    
    health_component.died.connect(on_died)

func on_died():
    # Get reference before we remove ourselves otherwise it won't be available
    var entities = get_tree().get_first_node_in_group("entities_layer")

    get_parent().remove_child(self)

    entities.add_child(self)

    $AnimationPlayer.play("default")

