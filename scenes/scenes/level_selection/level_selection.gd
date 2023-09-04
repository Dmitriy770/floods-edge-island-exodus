extends Control

var all_levels: Array[MenuItem] = []
var current_level_ind := 0

@onready var dialog_window := %Control as Control
@onready var dialog_window_animation := %DialogWindowAnimation as AnimationPlayer
@onready var header_label := %Header as Label
@onready var description_label := %Description as Label
@onready var status_label := %StatusLabel as Label
@onready var time_label := %TimeLabel as Label
@onready var tile_label := %TileLabel as Label
@onready var start_game_buttom := %StartGameButton as TextureButton

@onready var items_container := $MenuItems as Node2D

func _ready() -> void:
	dialog_window.hide()
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
	time_label.text = str(level_data.transit_time)
	tile_label.text = "N/A" if level_data.amount_spent_tiles == 0 else str(level_data.amount_spent_tiles)
	
	if level_data.state == LevelData.States.CLOSE:
		start_game_buttom.disabled = true
	else:
		start_game_buttom.disabled = false

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


func _on_exit_button_pressed():
	SceneManager.change_scene(SceneManager.Scenes.MAIN_MENU)


func _on_reset_button_pressed():
	dialog_window.show()
	dialog_window_animation.play('window_appear')


func _on_exit_dialog_button_pressed():
	dialog_window_animation.play_backwards('window_appear')
	await dialog_window_animation.animation_finished
	dialog_window.hide()

func _on_confirm_button_pressed():
	LevelsStorage.reset_all_levels_data()
	
	for item in items_container.get_children() as Array[MenuItem]:
		item._ready()
	check_levels_state()
	update_level_window()
	
	dialog_window_animation.play_backwards('window_appear')
	await dialog_window_animation.animation_finished
	dialog_window.hide()
