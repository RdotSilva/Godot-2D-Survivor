extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health


func damage(damage_amount: float):
	# Health should never be negative
	current_health = clamp(current_health - damage_amount, 0, max_health)
	
	# Refactor this in future when adding health pots
	health_changed.emit()

	# Logic used for health regen
	if damage_amount > 0:
		health_decreased.emit()

	Callable(check_death).call_deferred()


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		
		# Owner is the node that constitutes the root of the scene that this node exists in
		owner.queue_free()
