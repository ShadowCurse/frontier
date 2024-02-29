extends Node2D

class_name PlayerController

@onready var player_ui: PlayerUi = $CanvasLayer/player_ui

var characters: Array[Character]
var controlled_character: Character

enum State {
    Disabled,
    Idle,
    Run,
    Attack,
}

func _input(event: InputEvent) -> void:
      if self.controlled_character:
          if event.is_action_pressed("game_attack"):
              self.controlled_character.set_state(State.Attack)
              return
          if Input.get_vector("game_move_left", "game_move_right", "game_move_up", "game_move_down"):
              self.controlled_character.set_state(State.Run)
              return
          else:
              self.controlled_character.set_state(State.Idle)
              return

func update_timer(time_left: float) -> void:
    self.player_ui.update_timer(time_left)

func enable() -> void:
    self.player_ui.visible = true

func disable() -> void:
    self.player_ui.visible = false

func add_character(character: Character) -> void:
    self.characters.append(character)
    character.character_selected_signal.connect(self.switch_character)

func disconnect_character(character: Character) -> void:
    character.update_health_signal.disconnect(self.on_character_update_health_signal)
    character.update_exp_signal.disconnect(self.on_character_update_exp_signal)
    character.update_level_signal.disconnect(self.on_charcter_update_level_signal)
    character.dead_signal.disconnect(self.on_character_dead)

func connect_character(character: Character) -> void:
    character.update_health_signal.connect(self.on_character_update_health_signal)
    character.update_exp_signal.connect(self.on_character_update_exp_signal)
    character.update_level_signal.connect(self.on_charcter_update_level_signal)
    character.dead_signal.connect(self.on_character_dead)

func ui_track_character(character: Character) -> void:
    self.player_ui.track_character(character)
    self.player_ui.update_health(character.current_health, character.max_health)
    self.player_ui.update_exp(character.current_exp, character.level_exp)
    self.player_ui.update_level(character.current_level)

func select_character(character: Character) -> void:
    character.is_selected = true
    self.connect_character(character)
    self.ui_track_character(character)
    self.controlled_character = character

func switch_character(character: Character) -> void:
    self.controlled_character.is_selected = false
    self.disconnect_character(self.controlled_character)

    character.is_selected = true
    self.connect_character(character)
    self.ui_track_character(character)

    self.controlled_character = character

func on_character_dead(character: Character) -> void:
    var index = self.characters.find(character)
    character.queue_free()
    if index != -1:
        self.characters.remove_at(index)

    var next_character = self.characters.front()
    if next_character:
        self.connect_character(next_character)
        self.ui_track_character(next_character)
        self.controlled_character = next_character

func on_character_update_health_signal(current_health: int, max_health: int) -> void:
    self.player_ui.update_health(current_health, max_health)

func on_character_update_exp_signal(current_exp: int, level_exp: int) -> void:
    self.player_ui.update_exp(current_exp, level_exp)

func on_charcter_update_level_signal(current_level: int) -> void:
    self.player_ui.update_level(current_level)
