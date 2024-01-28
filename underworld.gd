extends Node2D

signal world_switch_signal

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_player_city_switch_worlds() -> void:
    self.world_switch_signal.emit()
