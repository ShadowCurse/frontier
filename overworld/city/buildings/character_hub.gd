extends Node2D

class_name CharacterHub

@onready var ui: Control = $ui

@export var overworld: Overworld
@export var knight_scene: PackedScene

var under_cursor_object: Node2D = null

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        self.ui.visible = false

func _process(_delta: float) -> void:
    if under_cursor_object:
        var cursor_pos = get_global_mouse_position()
        self.under_cursor_object.position = cursor_pos

        if Input.is_action_just_pressed("game_place_object"):
            self.overworld.activate_character(self.under_cursor_object)
            self.under_cursor_object = null

func on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action("game_attack"):
        self.ui.visible = true

func on_knight_button_pressed() -> void:
    self.ui.visible = false
    var knight: Player = self.knight_scene.instantiate()
    under_cursor_object = knight
    self.overworld.add_character(knight)
