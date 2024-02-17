extends CharacterBody2D

class_name Player

signal take_damage_signal(int)
signal player_selected_signal(Player)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_area: Area2D = $weapon_area
@onready var ui_root: CanvasLayer = $ui_root
@onready var ui: PlayerUi = $ui_root/ui

@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 20
@export var speed: float = 600.0

var current_state: PlayerController.State = PlayerController.State.Disabled

enum AttackDirection {
    None,
    Up,
    Down,
    Left,
    Right
}
var attacking_direction: AttackDirection = AttackDirection.None
var last_facing_direction_left: bool = true

func _physics_process(_delta: float) -> void:
    match self.current_state:
        PlayerController.State.Disabled:
            return
        PlayerController.State.Idle:
            return
        PlayerController.State.Run:
            var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")
            # Handle movement
            if direction:
                self.velocity = direction * self.speed
            else:
                self.velocity.x = move_toward(self.velocity.x, 0, self.speed)
                self.velocity.y = move_toward(self.velocity.y, 0, self.speed)
            self.move_and_slide()
        PlayerController.State.Attack:
            pass

func _process(_delta: float) -> void:
    match self.current_state:
        PlayerController.State.Disabled:
            return
        PlayerController.State.Idle:
            self.animated_sprite_2d.play("idle")
        PlayerController.State.Run:
            var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")
            # Handle spite directon flipping
            if direction:
                if direction.x <= 0.0:
                    self.animated_sprite_2d.flip_h = true
                    self.last_facing_direction_left = true
                else:
                    self.animated_sprite_2d.flip_h = false
                    self.last_facing_direction_left = false
            else:
                self.animated_sprite_2d.flip_h = self.last_facing_direction_left
            self.animated_sprite_2d.play("run")
        PlayerController.State.Attack:
            if self.attacking_direction != AttackDirection.None:
                return
            var mouse_position = get_global_mouse_position()
            var to_mouse = mouse_position - self.position
            var angle = to_mouse.angle()
            # Start motitoring weapon area
            self.weapon_area.visible = true
            self.weapon_area.monitoring = true
            # right
            if -PI / 4.0 <= angle && angle <= PI / 4.0:
                self.attacking_direction = AttackDirection.Right
                self.animated_sprite_2d.play("attack_right")
                self.animated_sprite_2d.flip_h = false
                self.last_facing_direction_left = false
                self.weapon_area.rotation = 0.0
            # left
            if 3.0 * PI / 4.0 <= angle || angle <= -3.0 * PI / 4.0:
                self.attacking_direction = AttackDirection.Left
                self.animated_sprite_2d.play("attack_right")
                self.animated_sprite_2d.flip_h = true
                self.last_facing_direction_left = true
                self.weapon_area.rotation = PI
            # up
            if -3.0 * PI / 4.0 <= angle && angle <= -PI / 4.0:
                self.attacking_direction = AttackDirection.Up
                self.animated_sprite_2d.play("attack_up")
                self.weapon_area.rotation = -PI / 2.0
            # down
            if PI / 4.0 <= angle && angle <= 3.0 * PI / 4.0:
                self.attacking_direction = AttackDirection.Down
                self.animated_sprite_2d.play("attack_down")
                self.weapon_area.rotation = PI / 2.0

func set_state(state: PlayerController.State) -> void:
   match self.current_state:
      PlayerController.State.Disabled:
          self.current_state = state
      PlayerController.State.Idle:
          self.current_state = state
      PlayerController.State.Run:
          self.current_state = state
      PlayerController.State.Attack:
          pass

func take_damage(damage: int) -> void:
    self.current_health -= damage
    self.take_damage_signal.emit(damage)

func on_animated_sprite_2d_animation_finished() -> void:
     match self.current_state:
        PlayerController.State.Disabled:
            return
        PlayerController.State.Idle:
            return
        PlayerController.State.Run:
            self.current_state = PlayerController.State.Idle
        PlayerController.State.Attack:
            self.current_state = PlayerController.State.Idle
            self.attacking_direction = AttackDirection.None
            self.weapon_area.visible = false
            self.weapon_area.monitoring = false

func on_weapon_area_body_entered(body: Node2D) -> void:
    if body is Enemy:
        body.take_damage(self.damage)

func on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event.is_action_pressed("game_attack"):
        self.player_selected_signal.emit(self)
