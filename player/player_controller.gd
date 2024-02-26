extends Node2D

class_name PlayerController

@onready var player_ui: PlayerUi = $CanvasLayer/player_ui

var players: Array[Player]
var controlled_player: Player

enum State {
    Disabled,
    Idle,
    Run,
    Attack,
}

func _ready() -> void:
    self.connect_player(self.controlled_player)
    self.ui_track_player(self.controlled_player)

func _input(event: InputEvent) -> void:
      if self.controlled_player:
          if event.is_action_pressed("game_attack"):
              self.controlled_player.set_state(State.Attack)
              return
          if Input.get_vector("game_move_left", "game_move_right", "game_move_up", "game_move_down"):
              self.controlled_player.set_state(State.Run)
              return
          else:
              self.controlled_player.set_state(State.Idle)
              return

func enable() -> void:
    self.player_ui.visible = true

func disable() -> void:
    self.player_ui.visible = false

func add_player(player: Player) -> void:
    self.players.append(player)

func disconnect_player(player: Player) -> void:
    player.is_selected = false
    player.update_health_signal.disconnect(on_player_update_health_signal)
    player.update_exp_signal.disconnect(on_player_update_exp_signal)
    player.update_level_signal.disconnect(on_player_update_level_signal)
    player.dead_signal.disconnect(on_player_dead)

func connect_player(player: Player) -> void:
    player.is_selected = true
    player.update_health_signal.connect(on_player_update_health_signal)
    player.update_exp_signal.connect(on_player_update_exp_signal)
    player.update_level_signal.connect(on_player_update_level_signal)
    player.dead_signal.connect(on_player_dead)

func ui_track_player(player: Player) -> void:
    self.player_ui.track_player(player)
    self.player_ui.update_health(player.current_health, player.max_health)
    self.player_ui.update_exp(player.current_exp, player.level_exp)
    self.player_ui.update_level(player.current_level)

func switch_player(player: Player) -> void:
    self.disconnect_player(self.controlled_player)
    self.connect_player(player)
    self.ui_track_player(player)
    self.controlled_player = player

func on_player_dead(player: Player) -> void:
    var index = self.players.find(player)
    player.queue_free()
    if index != -1:
        self.players.remove_at(index)

    var next_player = self.players.front()
    if next_player:
        self.connect_player(next_player)
        self.ui_track_player(next_player)
        self.controlled_player = next_player

func on_player_update_health_signal(current_health: int, max_health: int) -> void:
    self.player_ui.update_health(current_health, max_health)

func on_player_update_exp_signal(current_exp: int, level_exp: int) -> void:
    self.player_ui.update_exp(current_exp, level_exp)

func on_player_update_level_signal(current_level: int) -> void:
    self.player_ui.update_level(current_level)
