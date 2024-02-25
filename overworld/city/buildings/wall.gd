extends Node2D

class_name Wall

@onready var health_bar: ProgressBar = $health_bar

const building_gold_cost: int = 0
const building_wood_cost: int = 0
const building_stone_cost: int = 0

@export var max_health: int = 100
@export var current_health: int = 100

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func take_damage(damage: int) -> void:
    self.current_health -= damage
    var percent = float(self.current_health) / float(self.max_health)
    self.health_bar.set_value_no_signal(percent)
    
    if self.current_health <= 0:
        self.queue_free()
