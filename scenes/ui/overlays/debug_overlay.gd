extends CanvasLayer

## Debug Overlay - UI overlay for debug mode spawning
## Shows/hides based on debug mode toggle in options menu

@onready var spawn_xp_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/ItemsContainer/SpawnXpButton
@onready var spawn_rare_xp_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/ItemsContainer/SpawnRareXpButton
@onready var spawn_health_potion_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/ItemsContainer/SpawnHealthPotionButton
@onready var spawn_bomb_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/ItemsContainer/SpawnBombButton

@onready var spawn_basic_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/EnemiesContainer/SpawnBasicEnemyButton
@onready var spawn_wizard_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/EnemiesContainer/SpawnWizardEnemyButton
@onready var spawn_bat_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/EnemiesContainer/SpawnBatEnemyButton
@onready var spawn_ghost_boss_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/BossContainer/SpawnGhostBossButton
@onready var toggle_spawn_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/ControlsContainer/ToggleSpawnButton

var spawning_enabled: bool = true


func _ready():
	# Connect all button signals
	spawn_xp_button.pressed.connect(_on_spawn_xp_pressed)
	spawn_rare_xp_button.pressed.connect(_on_spawn_rare_xp_pressed)
	spawn_health_potion_button.pressed.connect(_on_spawn_health_potion_pressed)
	spawn_bomb_button.pressed.connect(_on_spawn_bomb_pressed)
	
	spawn_basic_enemy_button.pressed.connect(_on_spawn_basic_enemy_pressed)
	spawn_wizard_enemy_button.pressed.connect(_on_spawn_wizard_enemy_pressed)
	spawn_bat_enemy_button.pressed.connect(_on_spawn_bat_enemy_pressed)
	spawn_ghost_boss_button.pressed.connect(_on_spawn_ghost_boss_pressed)
	toggle_spawn_button.pressed.connect(_on_toggle_spawn_pressed)
	
	# Initialize toggle button text
	update_toggle_button_text()
	
	# Initially hide the overlay
	visible = false
	
	# Check debug mode state on ready
	update_visibility()


func _process(_delta):
	update_visibility()


func update_visibility():
	var OptionsMenu = load("res://scenes/ui/menus/options_menu.gd")
	visible = OptionsMenu.debug_mode_enabled


func _on_spawn_xp_pressed():
	spawn_item("spawn_experience_vial")


func _on_spawn_rare_xp_pressed():
	spawn_item("spawn_experience_vial_rare")


func _on_spawn_health_potion_pressed():
	spawn_item("spawn_health_potion")


func _on_spawn_bomb_pressed():
	spawn_item("spawn_bomb")


func _on_spawn_basic_enemy_pressed():
	spawn_enemy("spawn_basic_enemy")


func _on_spawn_wizard_enemy_pressed():
	spawn_enemy("spawn_wizard_enemy")


func _on_spawn_bat_enemy_pressed():
	spawn_enemy("spawn_bat_enemy")


func _on_spawn_ghost_boss_pressed():
	spawn_enemy("spawn_ghost_boss_enemy")


func spawn_item(method_name: String):
	var debug_manager = get_node_or_null("/root/Main/DebugManager")
	
	if debug_manager == null:
		push_error("DebugOverlay: DebugManager not found!")
		return
	
	if debug_manager.has_method(method_name):
		debug_manager.call(method_name)
	else:
		push_error("DebugOverlay: DebugManager doesn't have method: " + method_name)


func spawn_enemy(method_name: String):
	spawn_item(method_name)  # Same logic for enemies


func update_toggle_button_text():
	if spawning_enabled:
		toggle_spawn_button.text = "Stop Monster Spawns"
	else:
		toggle_spawn_button.text = "Resume Monster Spawns"
