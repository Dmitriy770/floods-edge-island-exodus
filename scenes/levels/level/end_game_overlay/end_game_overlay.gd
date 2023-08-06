class_name EndGameOverlay
extends CanvasLayer

var previous_scene: PackedScene = null
var is_open := false

@onready var header_label := %Header as Label
@onready var time_label := %TimeLabel as Label
@onready var tile_label := %TileLabel as Label

@onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready():
	hide()

func show_overlay(result: bool, transit_time: int, amount_spent_tiles: int, scene: PackedScene, level_name: String) -> void:
	if is_open:
		return
	is_open = true
	save_level_data(level_name, result, transit_time, amount_spent_tiles)
	previous_scene = scene
	show()
	animation_player.play("appearance_overlay")
	if result:
		header_label.text = "WIN"
	else:
		header_label.text = "LOSS"
	
	time_label.text = str(transit_time)
	tile_label.text = str(amount_spent_tiles)

func save_level_data(name: String, is_win: bool, time: float, tiles: int) -> void:
	var old_data := LevelsStorage.get_level_data(name)
	
	var data = LevelData.new()
	data.state = old_data.state
	if is_win:
		data.name = name
		data.state = LevelData.States.PASSED
		data.amount_spent_tiles = min(old_data.amount_spent_tiles if old_data.amount_spent_tiles != 0 else tiles, tiles)
		data.transit_time = min(old_data.transit_time, time)
		LevelsStorage.save_level_data(data)


func _on_start_game_button_pressed():
	var level_selection := load("res://scenes/scenes/level_selection/level_selection.tscn")
	SceneManager.change_scene(level_selection)


func _on_reset_game_button_pressed():
	SceneManager.change_scene(previous_scene)
