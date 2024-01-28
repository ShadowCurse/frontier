extends Node2D

class_name PlayerCity

@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func enable():
    self.camera_2d.enabled = true

func disable():
    self.camera_2d.enabled = false
