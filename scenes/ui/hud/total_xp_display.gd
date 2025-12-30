extends CanvasLayer

var total_xp: float = 0
@export var experience_manager: Node
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var level_label = $MarginContainer/VBoxContainer/LevelLabel


func _ready():
	# Reset total XP to 0 when scene loads (new match starts)
	total_xp = 0
	update_display()
	
	# Listen for experience vials being collected
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func on_experience_vial_collected(xp_amount: float):
	total_xp += xp_amount
	update_display()


func update_display():
	label.text = "Total XP: " + str(int(total_xp))
