extends CanvasLayer

@onready var paneL_container = %PanelContainer


func _ready():
    get_tree().paused = true
    $%ResumeButton.pressed.connect(_on_resume_pressed)

    $AnimationPlayer.play("default")

    var tween = create_tween()
    tween.tween_property(paneL_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(paneL_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _on_resume_pressed():
    $AnimationPlayer.play_backwards("default")

    var tween = create_tween()
    tween.tween_property(paneL_container, "scale", Vector2.ONE, 0)
    tween.tween_property(paneL_container, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

    await tween.finished

    get_tree().paused = false
    queue_free()