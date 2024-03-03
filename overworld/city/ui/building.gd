extends MarginContainer

class_name UiBuilding

signal pressed

@export var icon: Texture

@onready var building_icon: TextureRect = $HBoxContainer/building_icon
@onready var gold_cost: Label = $HBoxContainer/VBoxContainer/HBoxContainer/gold_cost
@onready var wood_cost: Label = $HBoxContainer/VBoxContainer/HBoxContainer/wood_cost
@onready var stone_cost: Label = $HBoxContainer/VBoxContainer/HBoxContainer/stone_cost
@onready var build_button: Button = $HBoxContainer/VBoxContainer/build_button

func _ready() -> void:
    self.building_icon.texture = self.icon

func set_cost(gold: int, wood: int, stone: int) -> void:
    self.gold_cost.text = "%d" % gold
    self.wood_cost.text = "%d" % wood
    self.stone_cost.text = "%d" % stone


func on_build_button_pressed() -> void:
    self.pressed.emit()
