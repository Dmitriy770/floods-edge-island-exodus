class_name Level1
extends Node2D

@onready var tile_map := $TileMap as TileMap
@onready var islands := $Islands as Node
@onready var player := $Player as Player
@onready var tile_counter_label := $Label as Label

var tile_counter := 15

func _ready() -> void:
	update_tile_counter(tile_counter)
	
	for island in islands.get_children() as Array[Island]:
		island.island_clicked.connect(on_island_clicked)
		add_tiles_from_island(island)

func update_tile_counter(amount: int) -> void:
	tile_counter_label.text = str(amount)
	tile_counter = amount

func _process(delta: float) -> void:
	if Input.is_action_pressed("action"):
		draw_ground()

func draw_ground() -> void:
	var tile_pos := tile_map.local_to_map(get_global_mouse_position())
	
	var layer := 1
	var coords: Array[Vector2i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			coords.append(Vector2i(tile_pos.x + x, tile_pos.y + y))

	var terrain_set = 0
	var terrain = 1
	
	var tile_data := tile_map.get_cell_tile_data(layer, tile_pos)
	
	if tile_data == null or tile_data.get_custom_data("is_can_build"):
		tile_map.set_cells_terrain_connect(layer, coords, terrain_set, terrain, true)
		update_tile_counter(tile_counter - 1)

func add_tiles_from_island(island: Island) -> void:
	for tile in island.get_all_tiles() as Array[TileInfo]:
		var coords := tile_map.local_to_map(island.global_position + tile.cords)
		tile_map.set_cell(1, coords, tile.source_id, tile.atlas_coords)
		
func on_island_clicked(island: Island) -> void:
	player.move_to_island(island)
