extends Node

@onready var overworld: Overworld = $overworld
@onready var underworld: Underworld = $underworld
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var is_overworld: bool = true

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

func on_world_switch():
    if self.is_overworld:
        self.overworld.world_leave();
        self.underworld.world_enter();
        self.is_overworld = false
    else:
        self.underworld.world_leave();
        self.overworld.world_enter();
        self.is_overworld = true
