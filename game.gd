extends Node

@export var overworld_scene: PackedScene
@export var underworld_scene: PackedScene

var overworld_node: Overworld
var underworld_node: Underworld

var is_overworld: bool = true

func _ready() -> void:
    var overworld = overworld_scene.instantiate()
    var underworld = underworld_scene.instantiate()
    underworld.visible = false;

    self.overworld_node = overworld
    self.underworld_node = underworld

    overworld.world_switch_signal.connect(on_world_switch)
    underworld.world_switch_signal.connect(on_world_switch)

    self.call_deferred("add_child", overworld)
    self.call_deferred("add_child", underworld)
    self.is_overworld = true

func _process(_delta: float) -> void:
    pass

func on_world_switch():
    if self.is_overworld:
        self.overworld_node.world_leave();
        self.underworld_node.world_enter();
        self.is_overworld = false
    else:
        self.underworld_node.world_leave();
        self.overworld_node.world_enter();
        self.is_overworld = true
