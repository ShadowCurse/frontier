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
@export var mine_scene: PackedScene
@export var food_hut_scene: PackedScene
@export var wood_cutter_scene: PackedScene
@export var wall_scene: PackedScene
@export var angled_wall_scene: PackedScene

@export var total_gold: int = 1000
@export var total_wood: int = 10000
@export var total_stone: int = 10000
@export var total_food: int = 2000

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
var mines: Array[Mine] = []
var food_huts: Array[FoodHut] = []
var wood_cutters: Array[WoodCutter] = []
var walls: Array[Wall] = []

var under_cursor_object: Node2D = null
var under_cursor_object_can_place: bool = false

func _ready() -> void:
    # initial ci ui update
    self.city_ui.set_gold(self.total_gold)
    self.city_ui.set_wood(self.total_wood)
    self.city_ui.set_stone(self.total_stone)
    self.city_ui.set_food(self.total_food)

    self.city_ui.set_house_cost(House.building_gold_cost, House.building_wood_cost, House.building_stone_cost)
    self.city_ui.set_mine_cost(Mine.building_gold_cost, Mine.building_wood_cost, Mine.building_stone_cost)
    self.city_ui.set_food_hut_cost(FoodHut.building_gold_cost, FoodHut.building_wood_cost, FoodHut.building_stone_cost)
    self.city_ui.set_wood_cutter_cost(WoodCutter.building_gold_cost, WoodCutter.building_wood_cost, WoodCutter.building_stone_cost)
    self.city_ui.set_wall_cost(Wall.building_gold_cost, Wall.building_wood_cost, Wall.building_stone_cost)
    
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
    if self.under_cursor_object:
        var cursor_pos = get_global_mouse_position()
        self.move_under_cursor_object(cursor_pos)
        
        if Input.is_action_just_pressed("game_rotate_object"):
            self.under_cursor_object.rotate(PI / 2)

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

func update_ui_resources() -> void:
    self.city_ui.set_gold(self.total_gold)
    self.city_ui.set_wood(self.total_wood)
    self.city_ui.set_stone(self.total_stone)

func try_deduce_cost(gold: int, wood: int, stone: int) -> bool:
    if self.total_gold < gold:
        return false
    if self.total_wood < wood:
        return false
    if self.total_stone < stone:
        return false

    self.total_gold -= gold
    self.total_wood -= wood
    self.total_stone -= stone

    self.update_ui_resources()

    return true

func on_city_ui_build_house_signal() -> void:
    if !self.try_deduce_cost(\
      House.building_gold_cost,\
      House.building_wood_cost,\
      House.building_stone_cost):
        return
    
    self.city_ui.hide_modes()

    var house: House = self.house_scene.instantiate()
    house.selected.connect(self.on_building_selected)
    house.spawn_character_signal.connect(self.on_spawn_character_signal)
    under_cursor_object = house
    self.grid_placement = GridPlacement.Building

    self.call_deferred("add_child", house)
    self.houses.append(house)
    
func on_city_ui_build_mine_signal() -> void:
    if !self.try_deduce_cost(\
      Mine.building_gold_cost,\
      Mine.building_wood_cost,\
      Mine.building_stone_cost):
        return

    self.city_ui.hide_modes()

    var mine: Mine = self.mine_scene.instantiate()
    mine.selected.connect(self.on_building_selected)
    under_cursor_object = mine
    self.grid_placement = GridPlacement.Building
    mine.stone_update_signal.connect(on_stone_update_signal)

    self.call_deferred("add_child", mine)
    self.mines.append(mine)
    
func on_city_ui_build_food_hut_signal() -> void:
    if !self.try_deduce_cost(\
      FoodHut.building_gold_cost,\
      FoodHut.building_wood_cost,\
      FoodHut.building_stone_cost):
        return

    self.city_ui.hide_modes()

    var food_hut: FoodHut = self.food_hut_scene.instantiate()
    food_hut.selected.connect(self.on_building_selected)
    under_cursor_object = food_hut
    self.grid_placement = GridPlacement.Building
    food_hut.food_update_signal.connect(on_food_update_signal)

    self.call_deferred("add_child", food_hut)
    self.food_huts.append(food_hut)
    
func on_city_ui_build_wood_cutter_signal() -> void:
    if !self.try_deduce_cost(\
      WoodCutter.building_gold_cost,\
      WoodCutter.building_wood_cost,\
      WoodCutter.building_stone_cost):
        return

    self.city_ui.hide_modes()

    var wood_cutter: WoodCutter = self.wood_cutter_scene.instantiate()
    wood_cutter.selected.connect(self.on_building_selected)
    under_cursor_object = wood_cutter
    self.grid_placement = GridPlacement.Building
    wood_cutter.wood_update_signal.connect(on_wood_update_signal)

    self.call_deferred("add_child", wood_cutter)
    self.wood_cutters.append(wood_cutter)
    
func on_city_ui_build_wall_signal() -> void:
    if !self.try_deduce_cost(\
      Wall.building_gold_cost,\
      Wall.building_wood_cost,\
      Wall.building_stone_cost):
        return

    self.city_ui.hide_modes()

    var wall: Wall = self.wall_scene.instantiate()
    wall.selected.connect(self.on_building_selected)
    under_cursor_object = wall
    self.grid_placement = GridPlacement.Building

    self.call_deferred("add_child", wall)
    self.walls.append(wall)

func on_city_ui_build_angled_wall_signal() -> void:
    if !self.try_deduce_cost(\
      Wall.building_gold_cost,\
      Wall.building_wood_cost,\
      Wall.building_stone_cost):
        return

    self.city_ui.hide_modes()

    var wall: Wall = self.angled_wall_scene.instantiate()
    wall.selected.connect(self.on_building_selected)
    under_cursor_object = wall
    self.grid_placement = GridPlacement.Building

    self.call_deferred("add_child", wall)
    self.walls.append(wall)

func on_building_selected(node: Node2D) -> void:
    match self.city_ui.interaction_mode:
        CityUi.InteractionMode.Build:
            pass
        CityUi.InteractionMode.Remove:
            self.total_gold += node.building_gold_cost
            self.total_wood += node.building_wood_cost
            self.total_stone += node.building_stone_cost
            self.update_ui_resources()
            node.queue_free()

func on_spawn_character_signal(character: Node2D) -> void:
    under_cursor_object = character
    self.grid_placement = GridPlacement.Character
    
    self.overworld.add_character(character)

func on_stone_update_signal(stone: int) -> void:
    self.total_stone += stone
    self.city_ui.set_stone(self.total_stone)
    
func on_food_update_signal(food: int) -> void:
    self.total_food = food
    self.city_ui.set_food(self.total_food)
    
func on_wood_update_signal(wood: int) -> void:
    self.total_wood += wood
    self.city_ui.set_wood(self.total_wood)

func on_city_area_body_entered(body: Node2D) -> void:
    if body is Character and body.is_selected:
        self.city_ui.visible = true
        self.player_entered.emit()

func on_city_area_body_exited(body: Node2D) -> void:
    if body is Character and body.is_selected:
        self.city_ui.visible = false
        self.player_exited.emit()
