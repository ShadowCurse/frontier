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
    self.controlled_player.take_damage_signal.connect(on_character_take_damage)

func _input(event: InputEvent) -> void:
      if event.is_action_pressed("game_attack"):
          self.controlled_player.set_state(State.Attack)
          return
      if Input.get_vector("game_left", "game_right", "game_up", "game_down"):
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
    self.controlled_player = node

func on_character_take_damage(damage: int) -> void:
    self.player_ui.update_health(self.current_health, self.max_health)
