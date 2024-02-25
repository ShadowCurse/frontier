extends Control

class_name CityUi

signal build_house_signal
signal build_gold_mine_signal
signal build_food_hut_signal
signal build_wood_cutter_signal
signal build_wall_signal
signal build_character_hub_signal

@onready var build_panel: PanelContainer = $build_panel

@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label
@onready var food_label: Label = $resources_panel/MarginContainer/HBoxContainer/food_label
@onready var stone_label: Label = $resources_panel/MarginContainer/HBoxContainer/stone_label
@onready var wood_label: Label = $resources_panel/MarginContainer/HBoxContainer/wood_label

@onready var house_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/house/HBoxContainer/house_button
@onready var gold_mine_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/gold_mine/HBoxContainer/gold_mine_button
@onready var food_hut_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/food_hut/HBoxContainer/food_hut_button
@onready var wood_cutter_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/wood_cutter/HBoxContainer/wood_cutter_button
@onready var wall_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/wall/HBoxContainer/wall_button
@onready var character_hub_button: Button = $build_panel/MarginContainer/ScrollContainer/Control/character_hub/HBoxContainer/character_hub_button

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
    
func on_gold_mine_button_pressed() -> void:
    self.build_gold_mine_signal.emit()
    
func on_food_hut_button_pressed() -> void:
    self.build_food_hut_signal.emit()
    
func on_wood_cutter_button_pressed() -> void:
    self.build_wood_cutter_signal.emit()

func on_wall_button_pressed() -> void:
    self.build_wall_signal.emit()

func on_character_hub_button_pressed() -> void:
    self.build_character_hub_signal.emit()

func set_house_cost(cost: int) -> void:
    self.house_button.text = "%d" % cost
    
func set_gold_mine_cost(cost: int) -> void:
    self.gold_mine_button.text = "%d" % cost

func set_food_hut_cost(cost: int) -> void:
    self.food_hut_button.text = "%d" % cost
    
func set_wood_cutter_cost(cost: int) -> void:
    self.wood_cutter_button.text = "%d" % cost

func set_wall_cost(cost: int) -> void:
    self.wall_button.text = "%d" % cost

func set_character_hub_cost(cost: int) -> void:
    self.character_hub_button.text = "%d" % cost

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
