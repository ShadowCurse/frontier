extends Node2D

class_name House

signal selected(Node2D)
signal spawn_character_signal(Node2D)

@onready var ui: Control = $ui
@onready var health_bar: ProgressBar = $health_bar

const building_gold_cost: int = 0
const building_wood_cost: int = 50
const building_stone_cost: int = 0

@export var knight_scene: PackedScene

@export var max_health: int = 100
@export var current_health: int = 100
var spawned_character: Node2D = null

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        self.ui.visible = false

func take_damage(damage: int) -> void:
    self.current_health -= damage
    var percent = float(self.current_health) / float(self.max_health)
    self.health_bar.set_value_no_signal(percent)
    
    if self.current_health <= 0:
        self.queue_free()

func on_knight_button_pressed() -> void:
    self.ui.visible = false
    var knight = self.knight_scene.instantiate()
    self.spawned_character = knight
    self.spawn_character_signal.emit(knight)

func on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action("game_select_building") && self.spawned_character == null:
        self.ui.visible = true
        self.selected.emit(self)
