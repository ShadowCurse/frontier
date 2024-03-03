extends Control

class_name CityUi

signal build_house_signal
signal build_mine_signal
signal build_food_hut_signal
signal build_wood_cutter_signal
signal build_wall_signal
signal build_angle_wall_signal
signal build_gate_signal

@onready var build_panel: PanelContainer = $build_panel

@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label
@onready var food_label: Label = $resources_panel/MarginContainer/HBoxContainer/food_label
@onready var stone_label: Label = $resources_panel/MarginContainer/HBoxContainer/stone_label
@onready var wood_label: Label = $resources_panel/MarginContainer/HBoxContainer/wood_label

@onready var house: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/house
@onready var mine: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/mine
@onready var food_hut: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/food_hut
@onready var wood_cutter: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter
@onready var wall: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/wall
@onready var angled_wall: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/angled_wall
@onready var gate: UiBuilding = $build_panel/MarginContainer/ScrollContainer/Control/gate

@onready var remove_mode_button: Button = $city_buttons/MarginContainer/HBoxContainer/remove_mode_button

enum InteractionMode {
    Build,
    Remove
}
var interaction_mode: InteractionMode = InteractionMode.Build

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass
    
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index != MOUSE_BUTTON_WHEEL_UP and event.button_index != MOUSE_BUTTON_WHEEL_DOWN:
            self.hide_modes()

func hide_modes() -> void:
    self.build_panel.visible = false

func on_house_pressed() -> void:
    self.build_house_signal.emit()
    
func on_mine_pressed() -> void:
    self.build_mine_signal.emit()
    
func on_food_hut_pressed() -> void:
    self.build_food_hut_signal.emit()
    
func on_wood_cutter_pressed() -> void:
    self.build_wood_cutter_signal.emit()

func on_wall_pressed() -> void:
    self.build_wall_signal.emit()

func on_angle_wall_pressed() -> void:
    self.build_angle_wall_signal.emit()

func on_gate_pressed() -> void:
    self.build_gate_signal.emit()

func set_house_cost(gold: int, wood: int, stone: int) -> void:
    self.house.set_cost(gold, wood, stone)
    
func set_mine_cost(gold: int, wood: int, stone: int) -> void:
    self.mine.set_cost(gold, wood, stone)

func set_food_hut_cost(gold: int, wood: int, stone: int) -> void:
    self.food_hut.set_cost(gold, wood, stone)

func set_wood_cutter_cost(gold: int, wood: int, stone: int) -> void:
    self.wood_cutter.set_cost(gold, wood, stone)

func set_wall_cost(gold: int, wood: int, stone: int) -> void:
    self.wall.set_cost(gold, wood, stone)
    self.angled_wall.set_cost(gold, wood, stone)

func set_gate_cost(gold: int, wood: int, stone: int) -> void:
    self.gate.set_cost(gold, wood, stone)

func set_gold(new_gold: int) -> void:
    self.gold_label.text = "%d" % new_gold
    
func set_food(new_food: int) -> void:
    self.food_label.text = "%d" % new_food
    
func set_stone(new_stone: int) -> void:
    self.stone_label.text = "%d" % new_stone 

func set_wood(new_wood: int) -> void:
    self.wood_label.text = "%d" % new_wood

func on_build_mode_button_pressed() -> void:
    self.build_panel.visible = true
    self.remove_mode_button.button_pressed = false
    self.interaction_mode = InteractionMode.Build

func on_remove_mode_button_toggled(toggled_on: bool) -> void:
    if toggled_on:
        self.interaction_mode = InteractionMode.Remove
    else:
        self.interaction_mode = InteractionMode.Build
