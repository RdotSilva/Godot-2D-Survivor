extends Node

var current_experience = 0


func increment_experience(number: float):
	current_experience += number
	print(current_experience)