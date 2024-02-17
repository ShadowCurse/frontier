extends Node2D

class_name Overworld

@onready var player: Player = $tile_map/player
@onready var player_city: PlayerCity = $tile_map/player_city
@onready var game_camera: Camera2D = $game_camera

@export var camera_city_zoom: float = 0.3
@export var camera_player_zoom: float = 0.8
@export_range(0, 10) var camera_smooth_weight: float = 0.1
@export_range(0, 10) var camera_transition_player: float = 2.0

var city_selected: bool = false

var player_camera_smooth: bool = false
var player_camera_weight: float = 0.0
const player_camera_weight_max: float = 1.0

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    if self.city_selected:
        # var camera_position = lerp(self.game_camera.global_position, self.player_city.global_position, self.camera_smooth_weight)
        var camera_zoom = lerp(self.game_camera.zoom, Vector2(self.camera_city_zoom, self.camera_city_zoom), self.camera_smooth_weight)
        self.game_camera.global_position = self.player.global_position #camera_position.floor()
        self.game_camera.zoom = camera_zoom
        self.player_camera_weight = 0.0
        self.player_camera_smooth = true
    else:
        if self.player_camera_weight < self.player_camera_weight_max:
            self.player_camera_weight += delta * self.camera_transition_player
        else:
            self.player_camera_smooth = false
            
        if self.player_camera_smooth:
            var camera_position = lerp(self.game_camera.global_position, self.player.global_position, self.player_camera_weight)
            var camera_zoom = lerp(self.game_camera.zoom, Vector2(self.camera_player_zoom, self.camera_player_zoom), self.player_camera_weight)
            self.game_camera.global_position = camera_position.floor()
            self.game_camera.zoom = camera_zoom
        else:
            self.game_camera.global_position = self.player.global_position

func world_enter() -> void:
    self.visible = true
    self.player.enable()

func world_leave() -> void:
    self.player.disable()
    self.visible = false

func on_player_city_player_entered() -> void:
    self.city_selected = true
    self.player.enable_city_ui()

func on_player_city_player_exited() -> void:
    self.city_selected = false
    self.player.disable_city_ui()
