extends CanvasLayer

@onready var paneL_container = %PanelContainer


func _ready():
    $AnimationPlayer.play("default")

    var tween = create_tween()
    tween.tween_property(paneL_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(paneL_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)