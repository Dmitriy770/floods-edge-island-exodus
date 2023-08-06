extends Control

func _on_exit_button_pressed():
	SceneManager.exit()

func _on_start_button_pressed():
	var level_selection_scene := load("res://scenes/scenes/level_selection/level_selection.tscn")
	SceneManager.change_scene(level_selection_scene)
