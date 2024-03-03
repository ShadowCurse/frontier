extends StaticBody2D

class_name Gate

signal selected(Node2D)

@onready var health_bar: ProgressBar = $health_bar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const building_gold_cost: int = 0
const building_wood_cost: int = 0
const building_stone_cost: int = 40

@export var max_health: int = 100
@export var current_health: int = 100

enum State {
    Opened,
    Closed,
}
var current_state: State = State.Closed
var characters_in_activation_area: int = 0

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func take_damage(damage: int) -> void:
    self.current_health -= damage
    var percent = float(self.current_health) / float(self.max_health)
    self.health_bar.set_value_no_signal(percent)
    
    if self.current_health <= 0:
        self.queue_free()

func on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_action("game_select_building"):
        self.selected.emit(self)


func on_activation_area_body_entered(body: Node2D) -> void:
    if body is Character:
        self.characters_in_activation_area += 1
        if self.characters_in_activation_area == 1:
            self.current_state = State.Opened
            self.animated_sprite_2d.play("open")

func on_activation_area_body_exited(body: Node2D) -> void:
    if body is Character:
        self.characters_in_activation_area -= 1
        if self.characters_in_activation_area == 0:
            self.current_state = State.Closed
            self.animated_sprite_2d.play("close")

func on_animated_sprite_2d_animation_finished() -> void:
    match self.current_state:
        State.Opened:
            self.collision_shape_2d.disabled = true
        State.Closed:
            self.collision_shape_2d.disabled = false
