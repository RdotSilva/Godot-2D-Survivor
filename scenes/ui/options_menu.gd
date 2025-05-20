extends CanvasLayer


@onready var window_button: Button = $%WindowButton
@onready var sfx_slider = $%SfxSlider
@onready var music_slider = $%MusicSlider


func _ready():
    $%WindowButton.pressed.connect(_on_window_button_pressed)


func update_display():
    window_button.text = "Windowed"

    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        window_button.text = "Fullscreen"

    sfx_slider.value = get_bus_volume_percent("sfx")
    music_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name: String):
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume_db = AudioServer.get_bus_volume_db(bus_index)

    return db_to_linear(volume_db)


func _on_window_button_pressed():
    var mode = DisplayServer.window_get_mode()

    if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    update_display()