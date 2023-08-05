class_name Island
extends Area2D

signal island_clicked(TestIsland)

@onready var target_position := ($TargetPosition as Marker2D).global_position
@onready var tile_map := $TileMap as TileMap

func _ready() -> void:
	tile_map.hide()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action"):
		island_clicked.emit(self)

func get_all_tiles() -> Array[TileInfo]:
	var tile_infos: Array[TileInfo] = []
	
	var size := tile_map.get_used_rect()
	for x in range(size.position.x, size.end.x):
		for y in range(size.position.y, size.end.y):
			for z in range(1, 3):
				var source_id = tile_map.get_cell_source_id(z, Vector2i(x,y))
				if source_id != -1:
					var atlas_coords = tile_map.get_cell_atlas_coords(z, Vector2i(x,y))
					var coords = tile_map.map_to_local(Vector2i(x, y))
					tile_infos.append(TileInfo.new(z, coords, source_id, atlas_coords))
	
	return tile_infos

func delete_tile_map() -> void:
	tile_map.queue_free()
