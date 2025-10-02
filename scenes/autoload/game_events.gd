extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal health_potion_collected(heal_amount: int)
signal boss_defeated


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()


func emit_health_potion_collected(heal_amount: int):
	health_potion_collected.emit(heal_amount)


func emit_boss_defeated():
	boss_defeated.emit()
