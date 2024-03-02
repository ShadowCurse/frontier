extends Control

class_name CityUi

signal build_house_signal
signal build_mine_signal
signal build_food_hut_signal
signal build_wood_cutter_signal
signal build_wall_signal
signal build_angle_wall_signal

@onready var build_panel: PanelContainer = $build_panel

@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label
@onready var food_label: Label = $resources_panel/MarginContainer/HBoxContainer/food_label
@onready var stone_label: Label = $resources_panel/MarginContainer/HBoxContainer/stone_label
@onready var wood_label: Label = $resources_panel/MarginContainer/HBoxContainer/wood_label

@onready var house_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/house/HBoxContainer/VBoxContainer/build_button
@onready var house_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/house/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var house_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/house/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost
@onready var house_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/house/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost

@onready var mine_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/mine/HBoxContainer/VBoxContainer/build_button
@onready var mine_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/mine/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var mine_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/mine/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost
@onready var mine_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/mine/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost

@onready var food_hut_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/food_hut/HBoxContainer/VBoxContainer/build_button
@onready var food_hut_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/food_hut/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var food_hut_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/food_hut/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost
@onready var food_hut_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/food_hut/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost


@onready var wood_cutter_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter/HBoxContainer/VBoxContainer/build_button
@onready var wood_cutter_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var wood_cutter_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost
@onready var wood_cutter_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost

@onready var wall_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/wall/HBoxContainer/VBoxContainer/build_button
@onready var wall_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wall/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var wall_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wall/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost
@onready var wall_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/wall/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost

@onready var angled_wall_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/angled_wall/HBoxContainer/VBoxContainer/build_button
@onready var angled_wall_gold_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/angled_wall/HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var angled_wall_wood_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/angled_wall/HBoxContainer/VBoxContainer/HBoxContainer/wood_cost
@onready var angled_wall_stone_cost: Label = $build_panel/MarginContainer/ScrollContainer/Control/angled_wall/HBoxContainer/VBoxContainer/HBoxContainer/stone_cost

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

func on_house_button_pressed() -> void:
    self.build_house_signal.emit()
    
func on_mine_button_pressed() -> void:
    self.build_mine_signal.emit()
    
func on_food_hut_button_pressed() -> void:
    self.build_food_hut_signal.emit()
    
func on_wood_cutter_button_pressed() -> void:
    self.build_wood_cutter_signal.emit()

func on_wall_button_pressed() -> void:
    self.build_wall_signal.emit()

func on_angle_wall_button_pressed() -> void:
    self.build_angle_wall_signal.emit()

func set_house_cost(gold: int, wood: int, stone: int) -> void:
    self.house_gold_cost.text = "%d" % gold
    self.house_wood_cost.text = "%d" % wood
    self.house_stone_cost.text = "%d" % stone
    
func set_mine_cost(gold: int, wood: int, stone: int) -> void:
    self.mine_gold_cost.text = "%d" % gold
    self.mine_wood_cost.text = "%d" % wood
    self.mine_stone_cost.text = "%d" % stone

func set_food_hut_cost(gold: int, wood: int, stone: int) -> void:
    self.food_hut_gold_cost.text = "%d" % gold
    self.food_hut_wood_cost.text = "%d" % wood
    self.food_hut_stone_cost.text = "%d" % stone

func set_wood_cutter_cost(gold: int, wood: int, stone: int) -> void:
    self.wood_cutter_gold_cost.text = "%d" % gold
    self.wood_cutter_wood_cost.text = "%d" % wood
    self.wood_cutter_stone_cost.text = "%d" % stone

func set_wall_cost(gold: int, wood: int, stone: int) -> void:
    self.wall_gold_cost.text = "%d" % gold
    self.wall_wood_cost.text = "%d" % wood
    self.wall_stone_cost.text = "%d" % stone
    
    self.angled_wall_gold_cost.text = "%d" % gold
    self.angled_wall_wood_cost.text = "%d" % wood
    self.angled_wall_stone_cost.text = "%d" % stone

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
