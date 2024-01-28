extends Node2D

class_name PlayerCastle

signal switch_worlds_signal

@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func enable():
    self.camera_2d.enabled = true

func disable():
    self.camera_2d.enabled = false

func on_teleport_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_pressed():
        switch_worlds_signal.emit()
