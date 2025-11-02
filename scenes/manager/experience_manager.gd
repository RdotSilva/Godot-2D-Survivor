extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const XP_MULTIPLIER = 1.25 # Each level requires 25% more XP than the previous

var current_experience = 0
var current_level = 1
var target_experience = 1


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	

func increment_experience(number: float):
	current_experience = min (current_experience + number, target_experience)
	experience_updated.emit(current_experience, target_experience)

	if current_experience == target_experience:
		current_level += 1
		target_experience = max(1, int(target_experience * XP_MULTIPLIER))
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)


func on_experience_vial_collected(number: float):
	increment_experience(number)