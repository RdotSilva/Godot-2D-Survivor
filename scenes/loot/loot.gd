# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var loot = generate_loot_pool()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# TODO: Implement loot pool generation