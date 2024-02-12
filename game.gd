extends Node

@onready var overworld: Overworld = $overworld
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_main_menu_start():
    self.canvas_layer.visible = false
    self.overworld.world_enter()

func on_main_menu_exit() -> void:
    get_tree().quit()

func on_main_menu_settings() -> void:
    pass # Replace with function body.
