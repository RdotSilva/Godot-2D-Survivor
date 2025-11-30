extends CanvasLayer

signal back_pressed

@onready var window_button: Button = $%WindowButton
@onready var sfx_slider = $%SfxSlider
@onready var music_slider = $%MusicSlider
@onready var back_button: Button = $%BackButton
@onready var save_button: Button = $%SaveButton
@onready var delete_save_button: Button = $%DeleteSaveButton
@onready var debug_mode_checkbox: CheckBox = $%DebugModeCheckBox

var confirmation_dialog: AcceptDialog

const SAVE_FILE_PATH = "user://game.save"

# Debug mode state (static so it persists across scenes)
static var debug_mode_enabled: bool = false

func _ready():
	back_button.pressed.connect(on_back_pressed)
	save_button.pressed.connect(on_save_pressed)
	delete_save_button.pressed.connect(on_delete_save_pressed)

	$%WindowButton.pressed.connect(_on_window_button_pressed)

	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))

	update_display()
	setup_confirmation_dialog()
	setup_debug_toggle()


func update_display():
	window_button.text = "Windowed"

	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"

	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")
	
	# Update debug toggle
	debug_mode_checkbox.button_pressed = debug_mode_enabled


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)

	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)

	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()

	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func on_back_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	
	back_pressed.emit()

func on_save_pressed():
	MetaProgression.save()
	
	# Provide user feedback
	var original_text = save_button.text
	save_button.text = "Saved!"
	save_button.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	save_button.text = original_text
	save_button.disabled = false


func setup_confirmation_dialog():
	confirmation_dialog = AcceptDialog.new()
	confirmation_dialog.dialog_text = "Are you sure you want to delete your save data? This action cannot be undone."
	confirmation_dialog.title = "Delete Save Data"
	confirmation_dialog.ok_button_text = "Delete"
	confirmation_dialog.add_cancel_button("Cancel")
	
	add_child(confirmation_dialog)
	confirmation_dialog.confirmed.connect(on_delete_confirmed)


func on_delete_save_pressed():
	confirmation_dialog.popup_centered()


func on_delete_confirmed():
	MetaProgression.delete_save()
	
	# Provide user feedback
	var original_text = delete_save_button.text
	delete_save_button.text = "Deleted!"
	delete_save_button.disabled = true
	
	await get_tree().create_timer(1.5).timeout
	delete_save_button.text = original_text
	delete_save_button.disabled = false

func setup_debug_toggle():
	# Connect debug toggle
	debug_mode_checkbox.button_pressed = debug_mode_enabled
	debug_mode_checkbox.toggled.connect(on_debug_mode_toggled)


func on_debug_mode_toggled(enabled: bool):
	debug_mode_enabled = enabled
	print("Debug mode: ", "ON" if enabled else "OFF")

# # TODO: Replace this with MetaProgression's save functionality
# func save():
# 	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
# 	file.store_var(save_data)
