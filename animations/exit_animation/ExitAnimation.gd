extends CanvasLayer


func exit():
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().quit()
