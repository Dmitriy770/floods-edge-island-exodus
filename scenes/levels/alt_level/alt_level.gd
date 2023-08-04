extends Node2D

@onready var islands := $Islands as Node
@onready var tile_map := $TileMap as TileMap
@onready var player := $Player as Player

func _ready() -> void:
	for island in islands.get_children() as Array[TestIsland]:
		island.island_clicked.connect(on_island_clicked)
		add_tiles_from_island(island)

func add_tiles_from_island(island: TestIsland) -> void:
	for tile in island.get_all_tiles() as Array[TileInfo]:
		var coords := tile_map.local_to_map(island.global_position + tile.cords)
		tile_map.set_cell(0, coords, tile.source_id, tile.atlas_coords)
		
func on_island_clicked(island: TestIsland) -> void:
	player.move_to_island(island)
