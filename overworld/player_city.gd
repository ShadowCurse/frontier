extends Node2D

class_name PlayerCity

signal switch_worlds_signal
signal population_update_signal(int)

@onready var camera_2d: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $Ui

@export var house_scene: PackedScene

var houses: Array[House] = []

var under_cursor_object: Node2D = null

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if under_cursor_object:
        var cursor_pos = get_global_mouse_position()
        under_cursor_object.position = cursor_pos

        if Input.is_action_just_pressed("game_place_object"):
            under_cursor_object = null

func enable():
    self.camera_2d.enabled = true
    self.ui.visible = true

func disable():
    self.camera_2d.enabled = false
    self.ui.visible = false

func on_teleport_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_pressed():
        switch_worlds_signal.emit()


func on_player_city_ui_build_house_signal() -> void:
    var house: House = self.house_scene.instantiate()
    under_cursor_object = house
    house.population_size_increase_signal.connect()

    self.call_deferred("add_child", house)
    self.houses.append(house)

func on_house_size_incease_signal() -> void:
    var total_population = 0
    for house in self.houses:
        total_population += house.current_population
    self.population_size_increase_signal.emit(total_population)


