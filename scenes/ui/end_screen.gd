extends CanvasLayer


func _ready():
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