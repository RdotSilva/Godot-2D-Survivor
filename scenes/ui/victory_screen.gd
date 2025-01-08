extends CanvasLayer


func _ready():
    get_tree().paused = true
    $%RestartButton.pressed.connect(on_restart_button_pressed)
    $%QuitButton.pressed.connect(on_quit_button_pressed)


func on_restart_button_pressed():
    # Change root node that is running the game
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")
