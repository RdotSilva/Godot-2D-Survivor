extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health


func damage(damage_amount: float):
	# Health should never be negative
	current_health = max(current_health - damage_amount, 0)

	# Refactor this in future when adding health pots
	health_changed.emit()

	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		
		# Owner is the node that constitutes the root of the scene that this node exists in
		owner.queue_free()
