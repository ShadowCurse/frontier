extends Node2D

class_name PlayerCity

signal switch_worlds_signal

@onready var camera_2d: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $Ui

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func enable():
    self.camera_2d.enabled = true
    self.ui.visible = true

func disable():
    self.camera_2d.enabled = false
    self.ui.visible = false

func on_teleport_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_pressed():
        switch_worlds_signal.emit()
