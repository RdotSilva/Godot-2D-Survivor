# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var loot = generate_loot_pool()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# TODO: Implement loot pool generation
func generate_loot_pool() -> void:
	var itemType = get_item_type()

	var quality = get_item_quality()

# TODO: Implement quality function
func get_item_quality() -> void:
	var quality = ['poor', 'common']


func get_item_type() -> void:
	var itemTypes = ['armor', 'weapon']


func get_item_slot() -> void:
	# Check for wespon

	# Check for armor