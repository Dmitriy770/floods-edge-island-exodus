extends Node

const  SAVE_GAME_FILE := "user://savegame.save"

func _ready() -> void:
	set_default_data()

func get_level_data(name: String) -> LevelData:
	var data = load_level_data().get(name)
	if data == null:
		return LevelData.new()
	
	var level_data := LevelData.new()
	level_data.state = data["state"]
	level_data.transit_time = data["transit_time"]
	level_data.amount_spent_tiles = data["amount_spent_tiles"]
	return level_data
	
func save_level_data(level: LevelData) -> void:
	var old_levels_data := load_level_data()

	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.WRITE)
	
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	
	old_levels_data[level.name] = {
		"state": level.state,
		"transit_time": level.transit_time,
		"amount_spent_tiles": level.amount_spent_tiles,
		}
	
	var json_object := JSON.new()
	save_game_file.store_line(json_object.stringify(old_levels_data))
	
func load_level_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_GAME_FILE):
		return {}
		
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.READ)
	
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return {}
	
	var json_object := JSON.new()
	var error = json_object.parse(save_game_file.get_line())
	
	if error != OK:
		return {}
	
	var data = json_object.get_data()
	return data

func reset_all_levels_data() -> void:
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.WRITE)
	
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	
	var json_object := JSON.new()
	save_game_file.store_line(json_object.stringify({}))
	set_default_data()

func set_default_data() -> void:
	var old_levels_data := load_level_data()
	
	if old_levels_data.is_empty():
		var default_level := LevelData.new()
		default_level.name = "level 1"
		default_level.state = LevelData.States.OPEN
		
		save_level_data(default_level)
