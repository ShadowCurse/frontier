extends Node2D

class_name EnemySpawner

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var overworld: Overworld
@export var default_target: Node2D
@export var enemy_scene: PackedScene
@export var rows: int = 3
@export var columns: int = 4

func spawn() -> void:
    var area_rect = collision_shape_2d.shape.get_rect()
    var width = area_rect.size.x
    var hight = area_rect.size.y
    # generate cells
    var offset_x = width / self.columns
    var offset_y = hight / self.rows
    var bottom_left_corner = self.position - Vector2(offset_x / 2.0 * (self.columns - 1), offset_y / 2 * (self.rows - 1))
    for x in range(self.columns):
        for y in range(self.rows):
            var enemy = self.enemy_scene.instantiate()
            enemy.position = bottom_left_corner + Vector2(x * offset_x, y * offset_y)
            enemy.default_target = self.default_target
            self.overworld.call_deferred("add_child", enemy)
