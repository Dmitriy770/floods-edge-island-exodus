extends Node2D

enum States {
	OPEN,
	CLOSE,
	PASSED,
}

const SPRITES := {
	States.OPEN: preload("res://assets/level_open_marker.png"),
	States.CLOSE: preload("res://assets/level_close_marker.png"),
	States.PASSED: preload("res://assets/level_passed_marker.png"),
}

var state := States.CLOSE

@onready var sprite := $Sprite2D as Sprite2D

func _ready() -> void:
	# state = [данные из БД]
	pass

func change_state(new_state: States) -> void:
	state = new_state
	sprite = SPRITES[state]
