extends Level

var counter := 0
var education_end := false

@onready var label1 := $Education/Control/PanelContainer/MarginContainer/Label as Label
@onready var label2 := $Education/Control/PanelContainer/MarginContainer/Label2 as Label
@onready var education := $Education as CanvasLayer

func _ready():
	super._ready()
	label1.show()
	label2.hide()

func _input(event: InputEvent) -> void:
	if not education_end and event.is_action_pressed("action"):
		counter +=1
		if counter == 1:
			label1.hide()
			label2.show()
		elif counter > 1:
			education_end = true
			education.queue_free()
