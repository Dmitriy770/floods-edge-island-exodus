extends Node2D

@onready var tile_map := $TileMap as TileMap
@onready var tile_counter_label := $Label as Label

var tile_counter := 15

func _ready() -> void:
	update_tile_counter(tile_counter)

func update_tile_counter(mount: int):
	tile_counter_label.text = str(mount)
	tile_counter = mount

func _process(delta: float) -> void:
	if Input.is_action_pressed("action"):
		draw_ground()

func draw_ground() -> void:
	var mouse_pos := get_global_mouse_position()
	var mouse_pos_map := tile_map.local_to_map(mouse_pos)
	
	var layer := 1
	var coords := [
		mouse_pos_map,
		Vector2i(mouse_pos_map[0] - 1, mouse_pos_map[1]),
		Vector2i(mouse_pos_map[0] + 1, mouse_pos_map[1]),
		Vector2i(mouse_pos_map[0], mouse_pos_map[1] + 1),
		Vector2i(mouse_pos_map[0], mouse_pos_map[1] - 1),
		Vector2i(mouse_pos_map[0] + 1, mouse_pos_map[1] + 1),
		Vector2i(mouse_pos_map[0] + 1, mouse_pos_map[1] - 1),
		Vector2i(mouse_pos_map[0] - 1, mouse_pos_map[1] - 1),
		Vector2i(mouse_pos_map[0] - 1, mouse_pos_map[1] + 1)
	]
	var terrain_set = 0
	var terrain = 1
	
	var tile_data := tile_map.get_cell_tile_data(layer, mouse_pos_map)
	
	if tile_data == null or tile_data.get_custom_data("is_can_build"):
		tile_map.set_cells_terrain_connect(layer, coords, terrain_set, terrain, true)
		update_tile_counter(tile_counter - 1)
