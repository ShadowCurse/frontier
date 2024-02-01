extends Control

signal build_house_signal

@onready var population_label: Label = $resources_panel/MarginContainer/HBoxContainer/population_label

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_house_button_pressed() -> void:
    self.build_house_signal.emit()

func on_population_update_signal(new_population: int) -> void:
    self.population_label.text = "%d" % new_population
