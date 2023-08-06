extends Control

var all_levels: Array[MenuItem] = []
var current_level_ind := 0

@onready var header_label := %Header as Label
@onready var description_label := %Description as Label
@onready var status_label := %StatusLabel as Label
@onready var time_label := %TimeLabel as Label
@onready var tile_label := %TileLabel as Label

@onready var items_container := $MenuItems as Node2D

func _ready() -> void:
	for item in items_container.get_children() as Array[MenuItem]:
		item.index = len(all_levels)
		item.level_selected.connect(on_level_selected)
		all_levels.append(item)
	check_levels_state()
	update_level_window()
	all_levels[current_level_ind].grab_focus()
	
func update_level_window() -> void:
	var current_level := all_levels[current_level_ind]
	var level_data := current_level.level_data
	
	header_label.text = current_level.level_name
	description_label.text = current_level.description
	status_label.text = get_string_state(level_data.state)
	tile_label.text = str(level_data.transit_time)
	tile_label.text = str(level_data.amount_spent_tiles)

func get_string_state(state: LevelData.States) -> String:
	match state:
		LevelData.States.OPEN:
			return "Open"
		LevelData.States.CLOSE:
			return "Close"
		LevelData.States.PASSED:
			return "Passed"
	return ""

func on_level_selected(index: int) -> void:
	current_level_ind = index
	update_level_window()

func check_levels_state() -> void:
	for i in range(0, len(all_levels) - 1):
		if all_levels[i].level_data.state == LevelData.States.PASSED \
			and all_levels[i+1].level_data.state == LevelData.States.CLOSE:
			all_levels[i+1].change_state(LevelData.States.OPEN)


func _on_start_game_button_pressed() -> void:
	all_levels[current_level_ind].start_game()
