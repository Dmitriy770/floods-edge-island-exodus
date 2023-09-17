extends Level

var counter := 0
var education_pause := false
var education_end := false

var island_hostile_explored := false
var island_resource_explored := false
var island_healing_explored := false

@onready var label1 := $Education/Control/PanelContainer/MarginContainer/Label as Label
@onready var label2 := $Education/Control/PanelContainer/MarginContainer/Label2 as Label
@onready var label3 := $Education/Control/PanelContainer/MarginContainer/HungerBar/Label3 as Label
@onready var label4 := $Education/Control/PanelContainer/MarginContainer/ToolsMenu/Label4 as Label
@onready var label5 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label5 as Label
@onready var label6 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label6 as Label
@onready var label7 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label7 as Label


@onready var hint3 := $Hints/Select as PointLight2D
@onready var hint4 := $Hints/PointLight2D2 as PointLight2D
@onready var hintIsland := $Education/Control/PanelContainer/MarginContainer/Control/PointLight2D3 as PointLight2D

@onready var education := $Education as CanvasLayer


func _ready():
	super._ready()
	label1.show()
	label2.hide()
	
	# test
	label3.hide()
	hint3.hide()
	
	label4.hide()
	hint4.hide()
	
	label5.hide()
	label6.hide()
	label7.hide()
	hintIsland.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and not education_pause and not education_end:
		counter +=1
		
		if counter == 1:
			label1.hide()
			label2.show()
			
		elif counter == 2:
			label2.hide()
			
			label3.show()
			hint3.show()
			
		elif counter == 3:
			label3.hide()
			hint3.hide()
			
			label4.show()
			hint4.show()
			
		elif counter == 4:
			label4.hide()
			hint4.hide()
			
			education.hide()
			education_pause = true
		
		elif counter == 5:
			label5.hide()
			hintIsland.hide()
			
			education.hide()
			education_pause = true
			
		elif counter == 6:
			label6.hide()
			hintIsland.hide()
			
			education.hide()
			education_pause = true
			
		elif counter == 7:
			label7.hide()
			hintIsland.hide()
			
			education.hide()
			
			education_end = true
			education.queue_free()
		


func _on_hostile_island_2_body_entered(_body):
	await get_tree().create_timer(0.3).timeout
	
	if not island_hostile_explored:
		island_hostile_explored = true
		education_pause = false
		
		education.show()
		label5.show()
		hintIsland.show()


func _on_healing_island_2_body_entered(_body):
	await get_tree().create_timer(0.3).timeout
	
	if not island_healing_explored:
		island_healing_explored = true
		education_pause = false
		
		education.show()
		label6.show()
		hintIsland.show()
		

func _on_resource_island_2_body_entered(_body):
	await get_tree().create_timer(0.3).timeout
	
	if not island_resource_explored:
		island_resource_explored = true
		education_pause = false
		
		education.show()
		label7.show()
		hintIsland.show()
