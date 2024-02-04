extends Node2D
class_name Village

signal player_enter_signal

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_area_2d_body_entered(body: Node2D) -> void:
    if body is PlayerCharacter:
        self.player_enter_signal.emit()
