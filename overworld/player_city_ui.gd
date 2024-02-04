extends Control

signal build_house_signal
signal build_gold_mine_signal
signal build_food_hut_signal
signal build_wood_cutter_signal

@onready var build_panel: PanelContainer = $build_panel
@onready var other_cities_panel: PanelContainer = $other_cities_panel

@onready var population_label: Label = $resources_panel/MarginContainer/HBoxContainer/population_label
@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label
@onready var food_label: Label = $resources_panel/MarginContainer/HBoxContainer/food_label
@onready var wood_label: Label = $resources_panel/MarginContainer/HBoxContainer/wood_label

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass
    
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        self.hide_modes()

func hide_modes() -> void:
    self.other_cities_panel.visible = false
    self.build_panel.visible = false

func on_house_button_pressed() -> void:
    self.hide_modes()
    self.build_house_signal.emit()
    
func on_gold_mine_button_pressed() -> void:
    self.hide_modes()
    self.build_gold_mine_signal.emit()
    
func on_food_hut_button_pressed() -> void:
    self.hide_modes()
    self.build_food_hut_signal.emit()
    
func on_wood_cutter_button_pressed() -> void:
    self.hide_modes()
    self.build_wood_cutter_signal.emit()

func on_population_update_signal(new_population: int) -> void:
    self.population_label.text = "%d" % new_population
    
func on_gold_update_signal(new_gold: int) -> void:
    self.gold_label.text = "%d" % new_gold
    
func on_food_update_signal(new_food: int) -> void:
    self.food_label.text = "%d" % new_food
    
func on_wood_update_signal(new_wood: int) -> void:
    self.wood_label.text = "%d" % new_wood

func on_build_mode_button_pressed() -> void:
    self.other_cities_panel.visible = false
    self.build_panel.visible = true

func on_other_cities_mode_button_pressed() -> void:
    self.build_panel.visible = false
    self.other_cities_panel.visible = true
