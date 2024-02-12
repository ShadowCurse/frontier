extends Node2D

class_name Overworld

@onready var player: Player = $tile_map/player
@onready var player_city: PlayerCity = $tile_map/player_city

var city_selected: bool = true

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func world_enter() -> void:
    self.visible = true
    self.player.enable()

func world_leave() -> void:
    self.player.disable()
    self.visible = false
