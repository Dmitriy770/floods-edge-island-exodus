extends Node

func change_scene(scene: PackedScene) -> void:
	await SceneAnimations.play_scene_exit()
	get_tree().change_scene_to_packed(scene)
	await SceneAnimations.play_scene_enter()
	
func exit() -> void:
	await SceneAnimations.play_scene_exit()
	get_tree().quit()
