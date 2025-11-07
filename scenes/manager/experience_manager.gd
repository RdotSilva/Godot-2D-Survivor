extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const XP_MULTIPLIER = 1.25 # Each level requires 25% more XP than the previous
const BASE_EXPERIENCE_REQUIRED = 20 # Starting XP needed for level 2

var current_experience = 0
var current_level = 1
var target_experience = BASE_EXPERIENCE_REQUIRED


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	

func increment_experience(number: float):
	current_experience += number

	# Handle multiple level ups if we gain more XP than needed
	while current_experience >= target_experience:
		current_level += 1
		current_experience -= target_experience
		target_experience = max(1, int(target_experience * XP_MULTIPLIER))
		level_up.emit(current_level)

	experience_updated.emit(current_experience, target_experience)


func on_experience_vial_collected(number: float):
	increment_experience(number)