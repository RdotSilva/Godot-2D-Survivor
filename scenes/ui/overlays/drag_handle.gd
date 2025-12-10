extends Control

var dragging = false
var offset = Vector2()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			dragging = mouse_event.pressed
			if dragging:
				var container = get_parent()
				var global_pos = get_global_transform() * mouse_event.position
				offset = global_pos - container.global_position
	
	elif event is InputEventMouseMotion and dragging:
		var container = get_parent()
		var motion_event = event as InputEventMouseMotion
		var global_pos = get_global_transform() * motion_event.position
		container.global_position = global_pos - offset
