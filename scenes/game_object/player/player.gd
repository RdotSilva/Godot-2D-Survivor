extends CharacterBody2D

@export var arena_time_manager: Node

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var shield_cooldown_timer = $ShieldCooldownTimer

var number_colliding_bodies = 0
var base_speed = 0
var has_shield_upgrade = false
var shield_active = false


func _ready() -> void:
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	base_speed = velocity_component.max_speed

	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	shield_cooldown_timer.timeout.connect(on_shield_cooldown_timeout)

	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	GameEvents.health_potion_collected.connect(on_health_potion_collected)
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)

	# Play animation only when player is moving
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")

	# Logic to flip the player animation based on moving direction
	var move_sign = sign(movement_vector.x)

	# Face place in correct location
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

# Return the input state used for movement
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	take_damage(1)
	damage_interval_timer.start()
	print(health_component.current_health)


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased():
	GameEvents.emit_player_damaged()
	$HitRandomStreamPlayer.play_random()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)
	elif ability_upgrade.id == "shield":
		has_shield_upgrade = true
		shield_active = true
		update_shield_indicator()


func on_health_potion_collected(heal_amount: int):
	health_component.heal(heal_amount)


func on_arena_difficulty_increased(difficulty: int):
	# Health regen logic to heal every 30 seconds
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regeneration_quantity > 0:
		var is_thirty_second_interval = (difficulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regeneration_quantity)


func take_damage(damage_amount: float):
	if has_shield_upgrade && shield_active:
		# Shield blocks the damage
		shield_active = false
		shield_cooldown_timer.start()
		update_shield_indicator()
		return
	
	# No shield or shield is on cooldown, take normal damage
	health_component.damage(damage_amount)


