extends CharacterBody2D

class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_area: Area2D = $weapon_area
@onready var ui_root: CanvasLayer = $ui_root
@onready var ui: PlayerUi = $ui_root/ui

@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 20
@export var speed: float = 600.0

enum State {
    Disabled,
    Idle,
    Run,
    Attack,   
}
var current_state: State = State.Disabled

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
        State.Disabled:
            return
        State.Idle:
            return
        State.Run:
            var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")
            # Handle movement
            if direction:
                self.velocity = direction * self.speed
            else:
                self.velocity.x = move_toward(self.velocity.x, 0, self.speed)
                self.velocity.y = move_toward(self.velocity.y, 0, self.speed)
            self.move_and_slide()
        State.Attack:
            pass

func _process(_delta: float) -> void:
    match self.current_state:
        State.Disabled:
            return
        State.Idle:
            if Input.get_vector("game_left", "game_right", "game_up", "game_down"):
                self.current_state = State.Run
                return
            if Input.is_action_pressed("game_attack"):
                self.current_state = State.Attack
                return
            self.animated_sprite_2d.play("idle")
        State.Run:
            if not Input.get_vector("game_left", "game_right", "game_up", "game_down"):
                self.current_state = State.Idle
                return
            if Input.is_action_pressed("game_attack"):
                self.current_state = State.Attack
                return
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
        State.Attack:
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

func enable() -> void:
    self.ui_root.visible = true
    self.visible = true
    self.current_state = State.Idle

func disable() -> void:
    self.ui_root.visible = false
    self.visible = false
    self.current_state = State.Disabled

func take_damage(damage: int) -> void:
    self.current_health -= damage
    self.ui.update_health(self.current_health, self.max_health)

func on_yello_village_player_enter_signal() -> void:
    self.ui.show_notification("Found Yello Village")

func on_purple_village_player_enter_signal() -> void:
    self.ui.show_notification("Found Purple Village")

func on_red_village_player_enter_signal() -> void:
    self.ui.show_notification("Found Red Village")

func on_animated_sprite_2d_animation_finished() -> void:
     match self.current_state:
        State.Disabled:
            return
        State.Idle:
            return
        State.Run:
            self.current_state = State.Idle
        State.Attack:
            self.current_state = State.Idle
            self.attacking_direction = AttackDirection.None
            self.weapon_area.visible = false
            self.weapon_area.monitoring = false


func on_weapon_area_body_entered(body: Node2D) -> void:
    if body is Enemy:
        body.take_damage(self.damage)
