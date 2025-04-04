extends CanvasLayer

@onready var paneL_container = $%PanelContainer

func _ready():
	paneL_container.pivot_offset = paneL_container.size / 2

	# Using the tween system as a workaround to animate the panel container
	var tween = create_tween()
	tween.tween_property(paneL_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(paneL_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)

# Sets the title and description labels when the user is defeated
func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You lost!"


func on_restart_button_pressed():
	get_tree().paused = false
	# Change root node that is running the game
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	get_tree().quit()
