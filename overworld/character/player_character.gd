extends CharacterBody2D

class_name PlayerCharacter

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var ui_root: CanvasLayer = $ui_root
@onready var character_ui: ChracterUi = $ui_root/character_ui

@export var speed: float = 600.0

var enabled: bool = true
var last_facing_direction_left: bool = true
var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
    if !self.enabled:
        return

    if Input.is_action_pressed("game_attack"):
        return

    var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")

    # Handle movement
    if direction:
        self.velocity = direction * self.speed
    else:
        self.velocity.x = move_toward(self.velocity.x, 0, self.speed)
        self.velocity.y = move_toward(self.velocity.y, 0, self.speed)
    self.move_and_slide()

func _process(_delta: float) -> void:
    if !self.enabled:
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

    self.is_attacking = Input.is_action_pressed("game_attack")

    # Handle animation
    if self.is_attacking:
        var mouse_position = get_global_mouse_position()
        var to_mouse = mouse_position - self.position
        var angle = to_mouse.angle()
        # right
        if -PI / 4.0 <= angle && angle <= PI / 4.0:
            self.animated_sprite_2d.play("attack_right")
            self.animated_sprite_2d.flip_h = false
            self.last_facing_direction_left = false
        # left
        if 3.0 * PI / 4.0 <= angle || angle <= -3.0 * PI / 4.0:
            self.animated_sprite_2d.play("attack_right")
            self.animated_sprite_2d.flip_h = true
            self.last_facing_direction_left = true
        # up
        if -3.0 * PI / 4.0 <= angle && angle <= -PI / 4.0:
            self.animated_sprite_2d.play("attack_up")
        # down
        if PI / 4.0 <= angle && angle <= 3.0 * PI / 4.0:
            self.animated_sprite_2d.play("attack_down")
    else:
        if direction:
            self.animated_sprite_2d.play("run")
        else:
            self.animated_sprite_2d.play("idle")

func enable():
    self.camera_2d.enabled = true
    self.ui_root.visible = true
    self.visible = true
    self.enabled = true

func disable():
    self.camera_2d.enabled = false
    self.ui_root.visible = false
    self.visible = false
    self.enabled = false

func on_yello_village_player_enter_signal() -> void:
    self.character_ui.show_notification("Found Yello Village")

func on_purple_village_player_enter_signal() -> void:
    self.character_ui.show_notification("Found Purple Village")

func on_red_village_player_enter_signal() -> void:
    self.character_ui.show_notification("Found Red Village")