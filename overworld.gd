extends Node2D

@onready var player_character: PlayerCharacter = $tile_map/player_character
@onready var player_city: PlayerCity = $player_city

var city_selected: bool = true

func _ready() -> void:
    pass # Replace with function body.

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("game_switch"):
        if self.city_selected:
            self.player_character.enable()
            self.player_city.disable()
            self.city_selected = false
        else:
            self.player_city.enable()
            self.player_character.disable()
            self.city_selected = true

func on_player_city_switch_worlds() -> void:
    print("switching worlds")
