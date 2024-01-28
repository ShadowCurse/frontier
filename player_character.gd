extends CharacterBody2D

class_name PlayerCharacter

const SPEED = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

var enabled: bool = true
var last_facing_direction_left: bool = true

func _physics_process(_delta: float) -> void:
    if !self.enabled:
        return

    var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")

    # Handle movement
    if direction:
        self.velocity = direction * SPEED
    else:
        self.velocity.x = move_toward(self.velocity.x, 0, SPEED)
        self.velocity.y = move_toward(self.velocity.y, 0, SPEED)
    self.move_and_slide()

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

    # Handle animation
    if direction:
        self.animated_sprite_2d.play("run")
    else:
        self.animated_sprite_2d.play("idle")

func enable():
    self.camera_2d.enabled = true
    self.enabled = true

func disable():
    self.camera_2d.enabled = false
    self.enabled = false
