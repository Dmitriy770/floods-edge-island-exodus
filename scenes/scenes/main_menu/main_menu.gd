extends Control


func _on_exit_button_pressed():
	ExitAnimation.exit()


func _on_start_button_pressed():
	ExitAnimation.change_scene("res://scenes/scenes/level_selection/level_selection.tscn")
