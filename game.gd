extends Node

@export var overworld_scene: PackedScene
@export var underworld_scene: PackedScene

var overworld_node: Node2D
var underworld_node: Node2D

var is_overworld: bool = true

func _ready() -> void:
    var overworld = overworld_scene.instantiate()
    var underworld = overworld_scene.instantiate()
    underworld.visible = false;

    self.overworld_node = overworld
    self.underworld_node = underworld


    overworld.world_switch_signal.connect(on_world_switch)
    underworld.world_switch_signal.connect(on_world_switch)

    self.call_deferred("add_child", overworld)
    self.is_overworld = true

func _process(_delta: float) -> void:
    pass

func on_world_switch():
    if self.is_overworld:
        self.overworld_node.visible = false;
        self.underworld_node.visible = true;
    else:
        self.overworld_node.visible = true;
        self.underworld_node.visible = false;
