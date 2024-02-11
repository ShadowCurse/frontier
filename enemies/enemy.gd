extends CharacterBody2D

class_name Enemy

@onready var player: Player = get_node("/root/game/overworld/tile_map/player")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var weapon_area: Area2D = $weapon_area
@onready var attack_timer: Timer = $attack_timer
@onready var health_bar: ProgressBar = $health_ui/health_bar
@onready var health_label: Label = $health_ui/health_label

@export var max_health: int = 100
@export var current_health: int = 100
@export var speed: float = 100.0
@export var attack_range: float = 100.0
@export var attack_speed: float = 1.0

enum State {
    Disabled,
    Idle,
    Persuit,
    Return,
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
var last_direction: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var is_persuing: bool = false
var damaged_this_attack: bool = false

func _ready() -> void:
    self.original_position = self.position
    self.health_bar.set_value_no_signal(1)

func _physics_process(delta: float) -> void:
    match self.current_state:
        State.Disabled:
            return
        State.Idle:
            return
        State.Persuit:
            self.velocity = self.last_direction * self.speed
            self.move_and_slide()
        State.Return:
            self.velocity = self.last_direction * self.speed
            self.move_and_slide()
        State.Attack:
            return
            
func _process(delta: float) -> void: 
    match self.current_state:
        State.Disabled:
            return
        State.Idle:
            if (self.position - player.position).length() < self.attack_range \
                 and self.attack_timer.is_stopped():
                self.current_state = State.Attack
                return
            if self.is_persuing:
                self.current_state = State.Persuit
                return
            self.animated_sprite_2d.play("idle")
        State.Persuit:
            if (self.position - player.position).length() < self.attack_range \
                 and self.attack_timer.is_stopped():
                self.current_state = State.Attack
                return
            self.navigation_agent_2d.set_target_position(player.position)
            self.last_direction = (self.navigation_agent_2d.get_next_path_position() - self.position).normalized()
            if last_direction.x < 0.0:
                self.animated_sprite_2d.flip_h = true
            else:
                self.animated_sprite_2d.flip_h = false
            self.animated_sprite_2d.play("run")
        State.Return:
            self.navigation_agent_2d.set_target_position(self.original_position)
            self.last_direction = (self.navigation_agent_2d.get_next_path_position() - self.position).normalized()
            if last_direction.x < 0.0:
                self.animated_sprite_2d.flip_h = true
            else:
                self.animated_sprite_2d.flip_h = false
            self.animated_sprite_2d.play("run")
        State.Attack:
            if !self.attack_timer.is_stopped():
                return
            self.attack_timer.start(self.attack_speed)
            var to_player = player.position - self.position
            var angle = to_player.angle()
            # Start motitoring weapon area
            self.weapon_area.visible = true
            self.weapon_area.monitoring = true
            # right
            if -PI / 4.0 <= angle && angle <= PI / 4.0:
                self.attacking_direction = AttackDirection.Right
                self.animated_sprite_2d.play("attack_right")
                self.animated_sprite_2d.flip_h = false
                self.weapon_area.rotation = 0.0
            # left
            if 3.0 * PI / 4.0 <= angle || angle <= -3.0 * PI / 4.0:
                self.attacking_direction = AttackDirection.Left
                self.animated_sprite_2d.play("attack_right")
                self.animated_sprite_2d.flip_h = true
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
            pass

func take_damage(damage: int) -> void:
    self.current_health -= damage
    var percent = float(self.current_health) / float(self.max_health)
    self.health_bar.set_value_no_signal(percent)
    self.health_label.text = "%d" % self.current_health

func on_follow_area_body_entered(body: Node2D) -> void:
    if body is Player:
        self.current_state = State.Persuit
        self.is_persuing = true

func on_follow_area_body_exited(body: Node2D) -> void:
    if body is Player:
        self.current_state = State.Return
        self.is_persuing = false

func on_navigation_agent_2d_target_reached() -> void:
    self.current_state = State.Idle
    
func on_animated_sprite_2d_animation_finished() -> void:
     match self.current_state:
        State.Disabled:
            return
        State.Idle:
            return
        State.Persuit or State.Return:
            self.current_state = State.Idle
        State.Attack:
            self.current_state = State.Idle
            self.attacking_direction = AttackDirection.None
            self.weapon_area.visible = false
            self.weapon_area.monitoring = false
            self.damaged_this_attack = false

func on_weapon_area_body_exited(body: Node2D) -> void:
    if body is Player and !self.damaged_this_attack:
        body.take_damage(10)
        self.damaged_this_attack = true
