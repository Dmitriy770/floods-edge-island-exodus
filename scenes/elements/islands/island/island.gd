class_name Island
extends Area2D

signal island_reached(island: Island)
signal island_clicked(island: Island)

@export var tile_amount := 10
@export var food_amount := 10 

var is_clickable := true

@onready var target_position := ($TargetPosition as Marker2D).global_position
@onready var tile_map := $TileMap as TileMap

func _ready() -> void:
	tile_map.hide()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action") && is_clickable:
		island_clicked.emit(self)
		show_selection_effect()

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

func show_selection_effect() -> void:
	tile_map.set_layer_modulate(3, Color("ffffff34"))
	await get_tree().create_timer(0.3).timeout
	tile_map.set_layer_modulate(3, Color("ffffff14"))

func clear_tile_map() -> void:
	tile_map.clear_layer(0)
	tile_map.clear_layer(1)
	tile_map.clear_layer(2)

func _on_mouse_entered():
	if is_clickable:
		tile_map.show()

func _on_mouse_exited():
	if is_clickable:
		tile_map.hide()

func enable_click() -> void:
	is_clickable = true

func disable_click() -> void:
	is_clickable = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		island_reached.emit(self)
		food_amount = 0
		tile_amount = 0
