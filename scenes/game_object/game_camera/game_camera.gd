extends Camera2D

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	aquire_target()

	# Formula used to create smooth "lerping"
	var framerate_smoothing_formula = 1.0 - exp(-delta * 20)

	global_position = global_position.lerp(target_position, framerate_smoothing_formula)
	

# Assign the target position only if the player exists
func aquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")

	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
