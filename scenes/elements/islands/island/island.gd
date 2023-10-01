class_name Island
extends Area2D

signal island_reached(island: Island)
signal island_clicked(island: Island)

@export var tile_amount := 10
@export var food_amount := 5
@export var landing_animation_name := ""

var is_clickable := true
var player : Player = null

@onready var target_position := ($TargetPosition as Marker2D).global_position
@onready var tile_map := $TileMap as TileMap
@onready var animation_player := $LandingAnimation/AnimationPlayer as AnimationPlayer
@onready var animation_container := $LandingAnimation as Node2D

func _ready() -> void:
	tile_map.hide()
	animation_container.hide()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action") && is_clickable:
		island_clicked.emit(self)
		show_selection_effect()

func get_all_tiles() -> Array[TileInfo]:
	var tile_infos: Array[TileInfo] = []
	
	var size := tile_map.get_used_rect()
	for x in range(size.position.x, size.end.x):
		for y in range(size.position.y, size.end.y):
			for z in range(1, 4):
				var source_id = tile_map.get_cell_source_id(z, Vector2i(x,y))
				if source_id != -1:
					var atlas_coords = tile_map.get_cell_atlas_coords(z, Vector2i(x,y))
					var coords = tile_map.map_to_local(Vector2i(x, y))
					tile_infos.append(TileInfo.new(z, coords, source_id, atlas_coords))
	
	return tile_infos

func show_selection_effect() -> void:
	tile_map.set_layer_modulate(4, Color("ffffff34"))
	await get_tree().create_timer(0.3).timeout
	tile_map.set_layer_modulate(4, Color("ffffff14"))

func clear_tile_map() -> void:
	tile_map.clear_layer(0)
	tile_map.clear_layer(1)
	tile_map.clear_layer(2)
	tile_map.clear_layer(3)

func _on_mouse_entered():
	if is_clickable:
		if player.can_move_to_island(self):
			tile_map.modulate = Color("ffffffff")
		else:
			tile_map.modulate = Color("ff0000ff")
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
		body.hide()
		animation_container.show()
		animation_player.play(landing_animation_name)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		animation_player.play_backwards(landing_animation_name)
		animation_container.hide()
		body.show()
