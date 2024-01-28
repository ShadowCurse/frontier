extends Node2D

class_name Underworld

signal world_switch_signal

@onready var player_castle: PlayerCastle = $player_castle

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func world_enter() -> void:
    self.visible = true
    self.player_castle.enable()

func world_leave() -> void:
    self.player_castle.disable()
    self.visible = false

func on_world_switch():
    self.world_switch_signal.emit()
