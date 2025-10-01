extends CanvasLayer

@onready var paneL_container = $%PanelContainer

func _ready():
	paneL_container.pivot_offset = paneL_container.size / 2

	# Using the tween system as a workaround to animate the panel container
	var tween = create_tween()
	tween.tween_property(paneL_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(paneL_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)

# Sets the title and description labels when the user is defeated
func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You lost!"
	play_jingle(true)


# Sets the title and description labels when the user wins
func set_victory():
	$%TitleLabel.text = "Victory"
	$%DescriptionLabel.text = "You won!"
	play_jingle(false)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()

func on_continue_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway

	get_tree().paused = false

	# Change root node that is running the game
	get_tree().change_scene_to_file("res://scenes/ui/menus/meta_menu.tscn")


func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/menus/main_menu.tscn")
	
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
