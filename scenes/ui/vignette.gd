extends CanvasLayer


func _ready() -> void:
    GameEvents.player_damaged.connect(on_player_damaged)


func on_player_damaged():
    # TODO: Add logic when player is damaged to show the vignette animation
    pass