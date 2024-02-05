extends Node2D

class_name Overworld

signal world_switch_signal

@onready var player: Player = $tile_map/player
@onready var player_city: PlayerCity = $tile_map/player_city

var city_selected: bool = true

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("game_switch"):
        if self.city_selected:
            self.player.enable()
            self.player_city.disable()
            self.city_selected = false
        else:
            self.player_city.enable()
            self.player.disable()
            self.city_selected = true

func world_enter() -> void:
    self.visible = true
    self.player.disable()
    self.player_city.enable()

func world_leave() -> void:
    self.player.disable()
    self.player_city.disable()
    self.visible = false

func on_world_switch():
    self.world_switch_signal.emit()
