class_name Level
extends Node2D

const FOOD_PER_SECOND := 0.05

@export var final_island: Island = null

var tile_amount := 15
var food_amount := 20.0
var is_action_press := false
var active_tool := HUD.Tools.CURSOR

@onready var tile_map := $TileMap as TileMap
@onready var islands_container := $Islands as Node
@onready var player := $Player as Player
@onready var hud := $Player/Camera2D/HUD as HUD

func _ready() -> void:
	hud.update_block_amount_label(tile_amount)
	hud.set_max_food(food_amount)
	hud.update_food_bar(food_amount)
	
	for island in islands_container.get_children() as Array[Island]:
		island.island_clicked.connect(on_island_clicked)
		island.island_reached.connect(on_island_reached)
		island.player = player
		add_tiles_from_island(island)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		is_action_press = true
	if event.is_action_released("action"):
		is_action_press = false

func _physics_process(_delta: float) -> void:
	if food_amount < 0 or tile_amount < 0:
		# print("end_game")
		pass
	
	if is_action_press and active_tool == HUD.Tools.BLOCK:
		draw_ground()

func draw_ground() -> void:
	var tile_pos := tile_map.local_to_map(get_global_mouse_position())
	
	var layer := 1
	var coords: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			coords.append(Vector2i(tile_pos.x + x, tile_pos.y + y))

	var terrain_set = 0
	var terrain = 1
	
	var tile_data := tile_map.get_cell_tile_data(layer, tile_pos)
	
	if tile_data == null or tile_data.get_custom_data("is_can_build"):
		tile_map.set_cells_terrain_connect(layer, coords, terrain_set, terrain, true)
		add_tiles(-1)

func add_tiles(amount: int) -> void:
	tile_amount += amount
	hud.update_block_amount_label(tile_amount)

func add_tiles_from_island(island: Island) -> void:
	var tiles := island.get_all_tiles()
	island.clear_tile_map()
	for tile in tiles:
		var coords := tile_map.local_to_map(island.global_position + tile.cords)
		tile_map.set_cell(tile.layer, coords, tile.source_id, tile.atlas_coords)

func on_island_clicked(island: Island) -> void:
	if active_tool == HUD.Tools.CURSOR:
		if player.can_move_to_island(island):
			player.move_to_island(island)
		else:
			print("нельзя добраться до острова")

func on_island_reached(island: Island) -> void:
	tile_amount += island.tile_amount
	food_amount += island.food_amount
	hud.update_food_bar(food_amount)
	hud.update_block_amount_label(tile_amount)
	
	if island == final_island:
		print("win_game")

func _on_hud_tool_changed(tool: HUD.Tools) -> void:
	active_tool = tool
	match tool:
		HUD.Tools.CURSOR:
			for island in islands_container.get_children() as Array[Island]:
				island.enable_click()
		HUD.Tools.BLOCK:
			for island in islands_container.get_children() as Array[Island]:
				island.disable_click()


func _on_food_timer_timeout():
	food_amount -= FOOD_PER_SECOND
	hud.update_food_bar(food_amount)
