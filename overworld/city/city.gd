extends Node2D

class_name City

signal player_entered
signal player_exited

@onready var grid_root: Node2D = $grid_root
@onready var city_ui: CityUi = $CanvasLayer/city_ui

@export var overworld: Overworld

@export var tile_scene: PackedScene
@export var tile_offset: float = 150.0
@export var grid_size: int = 9
@export var grid_clear_center_size: int = 1

@export var house_scene: PackedScene
@export var gold_mine_scene: PackedScene
@export var food_hut_scene: PackedScene
@export var wood_cutter_scene: PackedScene
@export var wall_scene: PackedScene
@export var character_hub_scene: PackedScene

@export var total_population: int = 0
@export var total_gold: int = 1000
@export var total_food: int = 2000
@export var total_wood: int = 10000

@export var house_gold_cost: int = 50
@export var gold_mine_wood_cost: int = 30
@export var food_hut_wood_cost: int = 20
@export var wood_cutter_wood_cost: int = 20
@export var wall_wood_cost: int = 90
@export var character_hub_food_cost: int = 50

@export var knight_gold_cost: int = CharacterHub.knight_gold_cost

class GridTile:
    var tile_node: Node2D
    # this magically becomes null  
    # when bulding is destroyed and calls queue_free() 
    var building_node: Node2D

# map of Vector2 to GridTile
var grid: Dictionary = {}

enum GridPlacement {
    Building,
    Character,
}
var grid_placement: GridPlacement = GridPlacement.Building

var houses: Array[House] = []
var gold_mines: Array[GoldMine] = []
var food_huts: Array[FoodHut] = []
var wood_cutters: Array[WoodCutter] = []
var walls: Array[Wall] = []

var under_cursor_object: Node2D = null
var under_cursor_object_can_place: bool = false

func _ready() -> void:
    # initial ci ui update
    self.city_ui.set_population(self.total_population)
    self.city_ui.set_gold(self.total_gold)
    self.city_ui.set_food(self.total_food)
    self.city_ui.set_wood(self.total_wood)

    self.city_ui.set_house_cost(self.house_gold_cost)
    self.city_ui.set_gold_mine_cost(self.gold_mine_wood_cost)
    self.city_ui.set_food_hut_cost(self.food_hut_wood_cost)
    self.city_ui.set_wood_cutter_cost(self.wood_cutter_wood_cost)
    self.city_ui.set_wall_cost(self.wall_wood_cost)
    self.city_ui.set_character_hub_cost(self.character_hub_food_cost)
    
    # generate cells
    var half_offset = self.tile_offset / 2.0
    var empty_delta = (self.grid_size - self.grid_clear_center_size) / 2.0
    var bottom_left_corner = self.position - Vector2(half_offset * (self.grid_size - 1), half_offset * (self.grid_size - 1))
    for x in range(self.grid_size):
        for y in range(self.grid_size):
            # skip cental nodes
            if empty_delta <= x && x < (self.grid_size - empty_delta) \
              || empty_delta <= y && y < (self.grid_size - empty_delta):
                    continue
            var tile = self.tile_scene.instantiate()
            tile.position = bottom_left_corner + Vector2(x * self.tile_offset, y * self.tile_offset)
            var grid_tile = GridTile.new()
            grid_tile.tile_node = tile
            grid_tile.building_node = null
            self.grid[tile.position] = grid_tile
            self.grid_root.call_deferred("add_child", tile)

func _process(_delta: float) -> void:
    if under_cursor_object:
        var cursor_pos = get_global_mouse_position()
        self.move_under_cursor_object(cursor_pos)

        if Input.is_action_just_pressed("game_place_object"):
            self.try_place_object()

func move_under_cursor_object(cursor_pos: Vector2):
    match self.grid_placement:
        GridPlacement.Building:
            for grid_tile_position in self.grid:
                var tile_left = grid_tile_position.x - self.tile_offset / 2.0
                var tile_right = grid_tile_position.x + self.tile_offset / 2.0
                var tile_top = grid_tile_position.y + self.tile_offset / 2.0
                var tile_bottom = grid_tile_position.y - self.tile_offset / 2.0
                var tile = self.grid[grid_tile_position]
                if tile_left < cursor_pos.x && cursor_pos.x < tile_right \
                && tile_bottom < cursor_pos.y && cursor_pos.y < tile_top \
                && tile.building_node == null:
                    self.under_cursor_object.position = grid_tile_position
                    self.under_cursor_object_can_place = true
                    return

            self.under_cursor_object_can_place = false
            self.under_cursor_object.position = cursor_pos
        GridPlacement.Character:
            self.overworld.activate_character(self.under_cursor_object)
            self.under_cursor_object.position = cursor_pos

func try_place_object() -> void:
    match self.grid_placement:
        GridPlacement.Building:
            if self.under_cursor_object_can_place:
                var tile = self.grid.get(self.under_cursor_object.position)
                if tile:
                    tile.building_node = self.under_cursor_object
                    self.under_cursor_object = null
        GridPlacement.Character:
            self.under_cursor_object = null

func set_ui(enabled: bool) -> void:
    self.city_ui.visible = enabled

func on_city_ui_build_house_signal() -> void:
    if self.total_gold < self.house_gold_cost:
        return
    
    self.total_gold -= self.house_gold_cost

    self.city_ui.hide_modes()
    self.city_ui.set_gold(self.total_gold)

    var house: House = self.house_scene.instantiate()
    under_cursor_object = house
    self.grid_placement = GridPlacement.Building
    house.population_update_signal.connect(on_population_incease_signal)

    self.call_deferred("add_child", house)
    self.houses.append(house)
    
func on_city_ui_build_gold_mine_signal() -> void:
    if self.total_wood < self.gold_mine_wood_cost:
        return

    self.total_wood -= self.gold_mine_wood_cost

    self.city_ui.hide_modes()
    self.city_ui.set_wood(self.total_wood)

    var gold_mine: GoldMine = self.gold_mine_scene.instantiate()
    under_cursor_object = gold_mine
    self.grid_placement = GridPlacement.Building
    gold_mine.gold_update_signal.connect(on_gold_update_signal)

    self.call_deferred("add_child", gold_mine)
    self.gold_mines.append(gold_mine)
    
func on_city_ui_build_food_hut_signal() -> void:
    if self.total_wood < self.food_hut_wood_cost:
        return

    self.total_wood -= self.food_hut_wood_cost

    self.city_ui.hide_modes()
    self.city_ui.set_wood(self.total_wood)

    var food_hut: FoodHut = self.food_hut_scene.instantiate()
    under_cursor_object = food_hut
    self.grid_placement = GridPlacement.Building
    food_hut.food_update_signal.connect(on_food_update_signal)

    self.call_deferred("add_child", food_hut)
    self.food_huts.append(food_hut)
    
func on_city_ui_build_wood_cutter_signal() -> void:
    if self.total_wood < self.wood_cutter_wood_cost:
        return

    self.total_wood -= self.wood_cutter_wood_cost

    self.city_ui.hide_modes()
    self.city_ui.set_wood(self.total_wood)

    var wood_cutter: WoodCutter = self.wood_cutter_scene.instantiate()
    under_cursor_object = wood_cutter
    self.grid_placement = GridPlacement.Building
    wood_cutter.wood_update_signal.connect(on_wood_update_signal)

    self.call_deferred("add_child", wood_cutter)
    self.wood_cutters.append(wood_cutter)
    
func on_city_ui_build_wall_signal() -> void:
    if self.total_wood < self.wall_wood_cost:
        return

    self.total_wood -= self.wall_wood_cost

    self.city_ui.hide_modes()
    self.city_ui.set_wood(self.total_wood)

    var wall: Wall = self.wall_scene.instantiate()
    under_cursor_object = wall
    self.grid_placement = GridPlacement.Building

    self.call_deferred("add_child", wall)
    self.walls.append(wall)

func on_city_ui_build_character_hub_signal() -> void:
    if self.total_food < self.character_hub_food_cost:
        return

    self.total_food -= self.character_hub_food_cost

    self.city_ui.hide_modes()
    self.city_ui.set_food(self.total_food)

    var character_hub: CharacterHub = self.character_hub_scene.instantiate()
    under_cursor_object = character_hub
    self.grid_placement = GridPlacement.Building
    character_hub.spawn_character_signal.connect(on_spawn_character_signal)

    self.call_deferred("add_child", character_hub)

func on_spawn_character_signal(scene: PackedScene) -> void:
    if self.total_gold < self.knight_gold_cost:
        return

    self.total_gold -= self.knight_gold_cost

    self.city_ui.hide_modes()
    self.city_ui.set_gold(self.total_gold)
    
    var knight: Player = scene.instantiate()
    
    under_cursor_object = knight
    self.grid_placement = GridPlacement.Character
    
    self.overworld.add_character(knight)

func on_population_incease_signal(population: int) -> void:
    self.total_population += population
    self.city_ui.set_population(self.total_population)

func on_gold_update_signal(gold: int) -> void:
    self.total_gold += gold
    self.city_ui.set_gold(self.total_gold)
    
func on_food_update_signal(food: int) -> void:
    self.total_food += food
    self.city_ui.set_food(self.total_food)
    
func on_wood_update_signal(wood: int) -> void:
    self.total_wood += wood
    self.city_ui.set_wood(self.total_wood)

func on_city_area_body_entered(body: Node2D) -> void:
    if body is Player and body.is_selected:
        self.city_ui.visible = true
        self.player_entered.emit()

func on_city_area_body_exited(body: Node2D) -> void:
    if body is Player and body.is_selected:
        self.city_ui.visible = false
        self.player_exited.emit()
