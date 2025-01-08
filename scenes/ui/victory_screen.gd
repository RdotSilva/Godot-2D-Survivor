extends CanvasLayer


func _ready():
    get_tree().paused = true
    $%RestartButton.pressed.connect(on_restart_button_pressed)
    $%QuitButton.pressed.connect(on_quit_button_pressed)