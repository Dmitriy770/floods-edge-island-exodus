class_name TileInfo
extends Object

var cords := Vector2.ZERO
var source_id := -1
var atlas_coords := Vector2i.ZERO

func _init(cords: Vector2, source_id: int, atlas_coords: Vector2i) -> void:
	self.cords = cords
	self.source_id = source_id
	self.atlas_coords = atlas_coords
