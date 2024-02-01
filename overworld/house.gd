extends Node2D

class_name House

signal population_update_signal(int)

@onready var timer: Timer = $Timer

@export var production_speed: float = 1.0
@export var max_population: int = 5

var current_population: int = 0

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if self.timer.is_stopped() and self.current_population < self.max_population:
        self.timer.start(1.0 / self.production_speed)

func on_timer_timeout() -> void:
    self.current_population += 1
    self.population_update_signal.emit(1)
