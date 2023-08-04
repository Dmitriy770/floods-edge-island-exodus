class_name Player
extends CharacterBody2D

@export var speed := 1000

var final_point := Vector2.ZERO

@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

func _process(delta: float) -> void:
	var direction := global_position.direction_to(navigation_agent.get_next_path_position())
	velocity = direction * speed * delta
	move_and_slide()

func move_to_island(island: TestIsland) -> void:
	navigation_agent.target_position = island.target_position.global_position
	if not navigation_agent.is_target_reachable():
		navigation_agent.target_position = global_position
