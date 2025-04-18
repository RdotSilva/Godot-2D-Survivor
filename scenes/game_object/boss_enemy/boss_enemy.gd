extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)