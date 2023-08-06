extends CanvasLayer


func exit():
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().quit()

func change_scene(location: String):
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(location)
	$AnimationPlayer.play_backwards('dissolve')
