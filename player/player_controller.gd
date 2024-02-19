extends Node2D

class_name PlayerController

@onready var player_ui: PlayerUi = $CanvasLayer/player_ui

@export var controlled_player: Player

enum State {
    Disabled,
    Idle,
    Run,
    Attack,
}

func _ready() -> void:
    self.controlled_player.update_health_signal.connect(on_character_update_health_signal)
    self.controlled_player.is_selected = true
    self.player_ui.track_player(self.controlled_player)

func _input(event: InputEvent) -> void:
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

func switch_player(node: Player) -> void:
    self.controlled_player.is_selected = false
    self.controlled_player = node
    self.controlled_player.is_selected = true
    self.controlled_player.update_health_signal.connect(on_character_update_health_signal)
    self.player_ui.track_player(self.controlled_player)
    self.player_ui.update_health(self.controlled_player.current_health, self.controlled_player.max_health)

func on_character_update_health_signal(current_health: int, max_health: int) -> void:
    self.player_ui.update_health(current_health, max_health)
