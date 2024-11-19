# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var loot = generate_loot_pool()