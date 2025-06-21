extends PanelContainer


@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

@onready var gui_input: Input = %GuiInput
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	gui_input.connect(on_gui_input)


func set_meta_upgrade(upgrade: MetaUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description

func select_card():
	$AnimationPlayer.play("selected")


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()


func on_upgrade_selected():
	$AnimationPlayer.play("selected")
	emit_signal("upgrade_selected", self)


func on_card_closed():
	$AnimationPlayer.play("closed")
	emit_signal("card_closed", self)