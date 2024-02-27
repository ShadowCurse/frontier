extends CharacterBody2D

class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var weapon_area: Area2D = $weapon_area
@onready var attack_timer: Timer = $attack_timer
@onready var health_bar: ProgressBar = $health_ui/health_bar
@onready var health_label: Label = $health_ui/health_label

@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 10
@export var speed: float = 100.0
@export var attack_range: float = 100.0
@export var attack_speed: float = 1.0
@export var on_death_exp: int = 80

enum State {
    Disabled,
    Idle,
    Persuit,
    Return,
    Attack,   
}
var current_state: State = State.Idle

enum AttackDirection {
    None,
    Up,
    Down,
    Left,
    Right
}
var attacking_direction: AttackDirection = AttackDirection.None

var targets: Array[Node2D]
var current_target: Node2D

var last_facing_direction_left: bool = true
var last_direction: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var is_persuing: bool = false

var objects_in_damage_area: Array[Node2D]

func _ready() -> void:
    self.original_position = self.global_position
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
            self.animated_sprite_2d.play("idle")
        State.Persuit:
            if (self.global_position - self.current_target.global_position).length() < self.attack_range \
                 and self.attack_timer.is_stopped():
                self.current_state = State.Attack
                return
            self.navigation_agent_2d.set_target_position(self.current_target.global_position)
            self.last_direction = (self.navigation_agent_2d.get_next_path_position() - self.global_position).normalized()
            if last_direction.x < 0.0:
                self.animated_sprite_2d.flip_h = true
            else:
                self.animated_sprite_2d.flip_h = false
            self.animated_sprite_2d.play("run")
        State.Return:
            self.navigation_agent_2d.set_target_position(self.original_position)
            self.last_direction = (self.navigation_agent_2d.get_next_path_position() - self.global_position).normalized()
            if last_direction.x < 0.0:
                self.animated_sprite_2d.flip_h = true
            else:
                self.animated_sprite_2d.flip_h = false
            self.animated_sprite_2d.play("run")
        State.Attack:
            if !self.attack_timer.is_stopped():
                return
            self.attack_timer.start(self.attack_speed)
            var to_player = self.current_target.global_position - self.global_position
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
    
    if self.current_health <= 0:
        if self.current_target is Character:
            self.current_target.gain_exp(self.on_death_exp)
        self.queue_free()

func on_follow_area_body_entered(body: Node2D) -> void:
    self.targets.append(body)
    if self.current_target != null:
        if body is Character:
            if body.is_selected:
                self.current_target = body
    else:
        self.current_target = body
        self.current_state = State.Persuit
        self.is_persuing = true

func on_follow_area_body_exited(body: Node2D) -> void:
    var index = self.targets.find(body)
    if index != -1:
        self.targets.remove_at(index)

    if self.current_target == body:
        self.current_target = self.targets.front()
        if not self.current_target:
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
        State.Persuit:
            return
        State.Return:
            return
        State.Attack:
            if self.is_persuing:
                self.current_state = State.Persuit
            else:
                self.current_state = State.Idle
            self.attacking_direction = AttackDirection.None

            # need to damage objects in the area
            # before disabling weapon area
            for body in self.objects_in_damage_area:
                if body.has_method("take_damage"):
                    body.take_damage(self.damage)

            self.weapon_area.visible = false
            self.weapon_area.monitoring = false

func on_weapon_area_body_entered(body: Node2D) -> void:
    self.objects_in_damage_area.append(body)

func on_weapon_area_body_exited(body: Node2D) -> void:
    var index = self.objects_in_damage_area.find(body)
    if index != -1:
        self.objects_in_damage_area.remove_at(index)
