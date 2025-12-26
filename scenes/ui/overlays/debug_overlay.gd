extends CanvasLayer

## Debug Overlay - UI overlay for debug mode spawning
## Shows/hides based on debug mode toggle in options menu

@onready var spawn_xp_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/ItemsContainer/SpawnXpButton
@onready var spawn_rare_xp_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/ItemsContainer/SpawnRareXpButton
@onready var spawn_health_potion_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/ItemsContainer/SpawnHealthPotionButton
@onready var spawn_bomb_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/ItemsContainer/SpawnBombButton

@onready var spawn_basic_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/EnemiesContainer/SpawnBasicEnemyButton
@onready var spawn_wizard_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/EnemiesContainer/SpawnWizardEnemyButton
@onready var spawn_bat_enemy_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/EnemiesContainer/SpawnBatEnemyButton
@onready var spawn_ghost_boss_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/LeftColumn/BossContainer/SpawnGhostBossButton
@onready var toggle_spawn_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/RightColumn/ControlsContainer/ToggleSpawnButton
@onready var toggle_freeze_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/RightColumn/ControlsContainer/ToggleFreezeButton
@onready var game_timer_button: Button = $DraggableContainer/PanelContainer/MarginContainer/MainContainer/RightColumn/ControlsContainer/GameTimerButton

var spawning_enabled: bool = true
var enemies_frozen: bool = false


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
	toggle_freeze_button.pressed.connect(_on_toggle_freeze_pressed)
	game_timer_button.pressed.connect(_on_game_timer_pressed)
	
	# Initialize toggle button text
	update_toggle_button_text()
	update_freeze_button_text()
	
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


func _on_toggle_spawn_pressed():
	var enemy_manager = get_node_or_null("/root/Main/EnemyManager")
	
	if enemy_manager == null:
		push_error("DebugOverlay: EnemyManager not found!")
		return
	
	spawning_enabled = !spawning_enabled
	
	if spawning_enabled:
		enemy_manager.resume_spawning()
	else:
		enemy_manager.stop_spawning()
	
	update_toggle_button_text()


func update_toggle_button_text():
	if spawning_enabled:
		toggle_spawn_button.text = "Stop Spawns"
	else:
		toggle_spawn_button.text = "Resume Spawns"


func _on_toggle_freeze_pressed():
	var enemy_manager = get_node_or_null("/root/Main/EnemyManager")
	
	if enemy_manager == null:
		push_error("DebugOverlay: EnemyManager not found!")
		return
	
	enemies_frozen = !enemies_frozen
	
	if enemies_frozen:
		enemy_manager.freeze_enemies()
	else:
		enemy_manager.unfreeze_enemies()
	
	update_freeze_button_text()


func update_freeze_button_text():
	if enemies_frozen:
		toggle_freeze_button.text = "Unfreeze Enemies"
	else:
		toggle_freeze_button.text = "Freeze Enemies"


func _on_game_timer_pressed():
	var arena_time_manager = get_node_or_null("/root/Main/ArenaTimeManager")
	
	if arena_time_manager == null:
		push_error("DebugOverlay: ArenaTimeManager not found!")
		return
	
	# Increment timer by 10 seconds
	arena_time_manager.increment_time(10.0)


func _on_increase_xp_pressed():
	# Emit the same signal that an XP vial would emit
	# This will trigger ExperienceManager and all other systems that listen to XP collection
	GameEvents.emit_experience_vial_collected(10.0)
