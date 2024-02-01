extends Control

signal build_house_signal
signal build_gold_mine_signal

@onready var population_label: Label = $resources_panel/MarginContainer/HBoxContainer/population_label
@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_house_button_pressed() -> void:
    self.build_house_signal.emit()
    
func on_gold_mine_button_pressed() -> void:
    self.build_gold_mine_signal.emit()

func on_population_update_signal(new_population: int) -> void:
    self.population_label.text = "%d" % new_population
    
func on_gold_update_signal(new_gold: int) -> void:
    self.gold_label.text = "%d" % new_gold
