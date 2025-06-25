extends PanelContainer


@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = %ProgressBar
@onready var purchase_button = $%PurchaseButton

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchased_pressed)
	gui_input.connect(on_gui_input)


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var percent = MetaProgression.save_data["meta_upgrade_currency"] / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1


func select_card():
	$AnimationPlayer.play("selected")


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()


func on_purchased_pressed():
	if upgrade == null:
		return
		
	MetaProgression.add_meta_upgrade(upgrade)