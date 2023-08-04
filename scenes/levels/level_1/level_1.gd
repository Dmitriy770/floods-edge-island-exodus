extends Node2D

@onready var tile_map := $TileMap as TileMap
@onready var tile_counter_label := $Label as Label

var mouse_left_down: bool = false
var tile_counter := 15

func _ready():
	update_tile_counter(tile_counter)

func update_tile_counter(mount):
	tile_counter_label.text = str(mount)
	tile_counter = mount


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
				
func _process(some_change):
	
	if mouse_left_down:
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
		
		if tile_data != null and tile_data.get_custom_data("is_can_build"):
			tile_map.set_cells_terrain_connect(layer, coords, terrain_set, terrain, true)
		
			update_tile_counter(tile_counter - 1)
		
