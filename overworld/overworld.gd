extends Node2D

class_name Overworld

@onready var player_controller: PlayerController = $player_controller
@onready var city: City = $city
@onready var game_camera: Camera2D = $game_camera
@onready var enemy_spawner: EnemySpawner = $enemy_spawner
@onready var wave_timer: Timer = $wave_timer

@export var starting_character: Character

@export var camera_city_zoom: float = 0.3
@export var camera_player_zoom: float = 0.8
@export_range(0, 10) var camera_smooth_weight: float = 0.1
@export_range(0, 10) var camera_transition_player: float = 2.0

var player_camera_smooth: bool = false
var player_camera_weight: float = 0.0
const player_camera_weight_max: float = 1.0

func _ready() -> void:
    self.player_controller.add_character(self.starting_character)
    self.player_controller.select_character(self.starting_character)

func _process(delta: float) -> void:
    self.player_controller.update_timer(self.wave_timer.time_left)
    var player = self.player_controller.controlled_character
    if player.in_city:
        var camera_position = lerp(self.game_camera.global_position, self.city.global_position, self.camera_smooth_weight)
        var camera_zoom = lerp(self.game_camera.zoom, Vector2(self.camera_city_zoom, self.camera_city_zoom), self.camera_smooth_weight)
        self.game_camera.global_position = camera_position.floor()
        self.game_camera.zoom = camera_zoom
        self.player_camera_weight = 0.0
        self.player_camera_smooth = true
    else:
        if self.player_camera_weight < self.player_camera_weight_max:
            self.player_camera_weight += delta * self.camera_transition_player
        else:
            self.player_camera_smooth = false
            
        if self.player_camera_smooth:
            var camera_position = lerp(self.game_camera.global_position, player.global_position, self.player_camera_weight)
            var camera_zoom = lerp(self.game_camera.zoom, Vector2(self.camera_player_zoom, self.camera_player_zoom), self.player_camera_weight)
            self.game_camera.global_position = camera_position.floor()
            self.game_camera.zoom = camera_zoom
        else:
            self.game_camera.global_position = player.global_position

func add_character(character: Character) -> void:
    self.call_deferred("add_child", character)

func activate_character(character: Character) -> void:
    character.character_selected_signal.connect(self.on_character_selected_signal)
    self.player_controller.add_character(character)

func world_enter() -> void:
    self.visible = true
    self.player_controller.enable()

func world_leave() -> void:
    self.player_controller.disable()
    self.visible = false

func on_player_city_player_entered() -> void:
    self.player_controller.controlled_character.in_city = true

func on_player_city_player_exited() -> void:
    self.player_controller.controlled_character.in_city = false

func on_character_selected_signal(character: Character) -> void:
    self.city.set_ui(character.in_city)

func on_wave_timer_timeout() -> void:
    self.enemy_spawner.spawn()
    self.wave_timer.wait_time *= 2.0
    self.wave_timer.start()
