extends Node

signal died

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health


func damage(damge: float):
	# Health should never be negative
	current_health = max(current_health - damage, 0)

	if current_health == 0:
		died.emit()
		
		# Owner is the node that constitutes the root of the scene that this node exists in
		owner.queue_free()