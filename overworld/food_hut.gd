extends Node2D

class_name FoodHut

signal food_update_signal(int)

@onready var timer: Timer = $Timer

@export var production_speed: float = 0.3

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if self.timer.is_stopped():
        self.timer.start(1.0 / self.production_speed)

func on_timer_timeout() -> void:
    self.food_update_signal.emit(1)
