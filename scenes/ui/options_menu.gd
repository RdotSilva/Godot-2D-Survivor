extends CanvasLayer


func _ready():
    $%WindowButton.pressed.connect(_on_window_button_pressed)


func _on_window_button_pressed():
    var mode = DisplayServer.window_get_mode()

    if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)