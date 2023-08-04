class_name Island
extends Area2D

signal island_clicked(TestIsland)

@onready var target_position = $TargetPosition as Marker2D
@onready var tile_map = $TileMap as TileMap

func _ready() -> void:
	tile_map.hide()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action"):
		island_clicked.emit(self)

func get_all_tiles() -> Array[TileInfo]:
	var tile_infos: Array[TileInfo]
	
	var size := tile_map.get_used_rect()
	for x in range(size.position.x, size.end.x):
		for y in range(size.position.y, size.end.y):
			var source_id = tile_map.get_cell_source_id(0, Vector2i(x,y))
			if source_id != -1:
				var atlas_coords = tile_map.get_cell_atlas_coords(0, Vector2i(x,y))
				var coords = tile_map.map_to_local(Vector2i(x, y))
				tile_infos.append(TileInfo.new(coords, source_id, atlas_coords))
	
	return tile_infos
