extends Node2D

class_name House

signal population_update_signal(int)

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

@export var production_speed: float = 1.0
@export var max_population: int = 5

var current_population: int = 0

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    var timer_time = 1.0 / self.production_speed
    var progress = (timer_time - self.timer.time_left) / timer_time
    self.progress_bar.value = progress
    if self.timer.is_stopped() and self.current_population < self.max_population:
        self.timer.start(timer_time)

func on_timer_timeout() -> void:
    self.current_population += 1
    self.population_update_signal.emit(1)
