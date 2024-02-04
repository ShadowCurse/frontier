extends Node2D

class_name PlayerCity

signal switch_worlds_signal
signal population_update_signal(int)
signal gold_update_signal(int)
signal food_update_signal(int)
signal wood_update_signal(int)

@onready var camera_2d: Camera2D = $Camera2D
@onready var ui_root: CanvasLayer = $ui_root
@onready var city_ui: Control = $ui_root/city_ui
@onready var grid_root: Node2D = $grid_root

@export var tile_scene: PackedScene
@export var tile_offset: float = 150.0
@export var grid_size: int = 6
@export var grid_clear_center_size: int = 2

@export var house_scene: PackedScene
@export var gold_mine_scene: PackedScene
@export var food_hut_scene: PackedScene
@export var wood_cutter_scene: PackedScene

class GridTile:
    var node: Node2D
    var occupied: bool

# map of Vector2 to GridTile
var grid: Dictionary = {}

var houses: Array[House] = []
var gold_mines: Array[GoldMine] = []
var food_huts: Array[FoodHut] = []
var wood_cutters: Array[WoodCutter] = []

var total_population: int = 0
var total_gold: int = 0
var total_food: int = 0
var total_wood: int = 0

var under_cursor_object: Node2D = null
var under_cursor_object_can_place: bool = false

func _ready() -> void:
    var half_offset = self.tile_offset / 2.0
    var empty_delta = (self.grid_size - self.grid_clear_center_size) / 2.0
    var bottom_left_corner = self.position - Vector2(half_offset * (self.grid_size - 1), half_offset * (self.grid_size - 1))
    for x in range(self.grid_size):
        for y in range(self.grid_size):
            # skip cental nodes
            if empty_delta <= x && x < (self.grid_size - empty_delta) \
              && empty_delta <= y && y < (self.grid_size - empty_delta):
                    continue
            var tile = self.tile_scene.instantiate()
            tile.position = bottom_left_corner + Vector2(x * self.tile_offset, y * self.tile_offset)
            var grid_tile = GridTile.new()
            grid_tile.node = tile
            grid_tile.occupied = false
            self.grid[tile.position] = grid_tile
            self.grid_root.call_deferred("add_child", tile)

func _process(_delta: float) -> void:
    if under_cursor_object:
        var cursor_pos = get_global_mouse_position()
        self.move_under_cursor_object(cursor_pos)

        if Input.is_action_just_pressed("game_place_object"):
            self.try_place_object()

func enable():
    self.camera_2d.enabled = true
    self.ui_root.visible = true

func disable():
    self.camera_2d.enabled = false
    self.ui_root.visible = false

func move_under_cursor_object(cursor_pos: Vector2):
    for grid_tile_position in self.grid:
        var tile_left = grid_tile_position.x - self.tile_offset / 2.0
        var tile_right = grid_tile_position.x + self.tile_offset / 2.0
        var tile_top = grid_tile_position.y + self.tile_offset / 2.0
        var tile_bottom = grid_tile_position.y - self.tile_offset / 2.0
        var tile = self.grid[grid_tile_position]
        if tile_left < cursor_pos.x && cursor_pos.x < tile_right \
          && tile_bottom < cursor_pos.y && cursor_pos.y < tile_top \
          && tile.occupied == false:
            self.under_cursor_object.position = grid_tile_position
            self.under_cursor_object_can_place = true
            return

    self.under_cursor_object_can_place = false
    self.under_cursor_object.position = cursor_pos

func try_place_object():
    if self.under_cursor_object_can_place:
        var tile = self.grid.get(self.under_cursor_object.position)
        if tile:
            tile.occupied = true
            self.under_cursor_object = null

func on_teleport_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event.is_pressed():
        switch_worlds_signal.emit()

func on_city_ui_build_house_signal() -> void:
    var house: House = self.house_scene.instantiate()
    under_cursor_object = house
    house.population_update_signal.connect(on_population_incease_signal)

    self.call_deferred("add_child", house)
    self.houses.append(house)
    
func on_city_ui_build_gold_mine_signal() -> void:
    var gold_mine: GoldMine = self.gold_mine_scene.instantiate()
    under_cursor_object = gold_mine
    gold_mine.gold_update_signal.connect(on_gold_update_signal)

    self.call_deferred("add_child", gold_mine)
    self.gold_mines.append(gold_mine)
    
func on_city_ui_build_food_hut_signal() -> void:
    var food_hut: FoodHut = self.food_hut_scene.instantiate()
    under_cursor_object = food_hut
    food_hut.food_update_signal.connect(on_food_update_signal)

    self.call_deferred("add_child", food_hut)
    self.food_huts.append(food_hut)
    
func on_city_ui_build_wood_cutter_signal() -> void:
    var wood_cutter: WoodCutter = self.wood_cutter_scene.instantiate()
    under_cursor_object = wood_cutter
    wood_cutter.wood_update_signal.connect(on_wood_update_signal)

    self.call_deferred("add_child", wood_cutter)
    self.wood_cutters.append(wood_cutter)

func on_population_incease_signal(population: int) -> void:
    self.total_population += population
    self.population_update_signal.emit(self.total_population)

func on_gold_update_signal(gold: int) -> void:
    self.total_gold += gold
    self.gold_update_signal.emit(self.total_gold)
    
func on_food_update_signal(food: int) -> void:
    self.total_food += food
    self.food_update_signal.emit(self.total_food)
    
func on_wood_update_signal(wood: int) -> void:
    self.total_wood += wood
    self.wood_update_signal.emit(self.total_wood)


