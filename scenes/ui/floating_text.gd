extends Node2D

func start(text: String):
    $Label.text = text

    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)