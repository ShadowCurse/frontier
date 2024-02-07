extends CharacterBody2D

class_name Enemy

@onready var player: Player = get_node("/root/game/overworld/tile_map/player")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

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
var last_direction: Vector2 = Vector2.ZERO
var is_following: bool = false

func _physics_process(delta: float) -> void:
    match self.current_state:
        State.Disabled:
            return
        State.Idle:
            return
        State.Run:
            # Handle movement
            if self.last_direction:
                self.velocity = self.last_direction * self.speed
            else:
                self.velocity.x = move_toward(self.velocity.x, 0, self.speed)
                self.velocity.y = move_toward(self.velocity.y, 0, self.speed)
            self.move_and_slide()
        State.Attack:
            pass
            
func _process(delta: float) -> void:
    if self.is_following:
        self.navigation_agent_2d.target_position = player.position
        self.position = self.navigation_agent_2d.get_next_path_position()

func on_follow_area_body_entered(body: Node2D) -> void:
    if body is Player:
        self.is_following = true

func on_follow_area_body_exited(body: Node2D) -> void:
    if body is Player:
        self.is_following = false
