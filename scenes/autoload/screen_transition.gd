extends CanvasLayer

signal transition_halfway


func transition():
    $AnimationPlayer.play("default")


func emit_transitioned_halfway():
    transition_halfway.emit()