extends Node2D

class_name PlayerCity

signal switch_worlds_signal
signal population_update_signal(int)
signal gold_update_signal(int)

@onready var camera_2d: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $Ui

@export var house_scene: PackedScene
@export var gold_mine_scene: PackedScene

var houses: Array[House] = []
var gold_mines: Array[GoldMine] = []

var total_population: int = 0
var total_gold: int = 0

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
    house.population_update_signal.connect(on_population_incease_signal)

    self.call_deferred("add_child", house)
    self.houses.append(house)
    
func on_player_city_ui_build_gold_mine_signal() -> void:
    var gold_mine: GoldMine = self.gold_mine_scene.instantiate()
    under_cursor_object = gold_mine
    gold_mine.gold_update_signal.connect(on_gold_update_signal)

    self.call_deferred("add_child", gold_mine)
    self.gold_mines.append(gold_mine)

func on_population_incease_signal(population: int) -> void:
    self.total_population += population
    self.population_update_signal.emit(self.total_population)

func on_gold_update_signal(gold: int) -> void:
    self.total_gold += gold
    self.gold_update_signal.emit(self.total_gold)


