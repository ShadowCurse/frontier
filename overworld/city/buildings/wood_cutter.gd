extends Node2D

class_name WoodCutter

signal wood_update_signal(int)

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_bar: ProgressBar = $health_bar

const building_gold_cost: int = 0
const building_wood_cost: int = 0
const building_stone_cost: int = 0

@export var production_speed: float = 0.3
@export var max_health: int = 100
@export var current_health: int = 100

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    var timer_time = 1.0 / self.production_speed
    var progress = (timer_time - self.timer.time_left) / timer_time
    self.progress_bar.value = progress
    if self.timer.is_stopped():
        self.timer.start(timer_time)

func take_damage(damage: int) -> void:
    self.current_health -= damage
    var percent = float(self.current_health) / float(self.max_health)
    self.health_bar.set_value_no_signal(percent)
    
    if self.current_health <= 0:
        self.queue_free()

func on_timer_timeout() -> void:
    self.wood_update_signal.emit(1)
