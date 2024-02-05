extends Node2D

@onready var game_map: TileMap = get_node("/root/game/overworld/tile_map")
@onready var player: Player = get_node("/root/game/overworld/tile_map/player")

@onready var tile_map: TileMap = $TileMap
@onready var player_icon: Sprite2D = $TileMap/player_icon

func _ready() -> void:
    for cell_coord in game_map.get_used_cells(2):
        var atlas_coords = game_map.get_cell_atlas_coords(2, cell_coord)
        var source_id = game_map.get_cell_source_id(2, cell_coord)
        self.tile_map.set_cell(0, cell_coord, source_id, atlas_coords)

func _process(_delta: float) -> void:
    self.player_icon.position = player.position
