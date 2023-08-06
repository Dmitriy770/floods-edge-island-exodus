extends CanvasLayer

@onready var header_label := %Header as Label
@onready var time_label := %TimeLabel as Label
@onready var tile_label := %TileLabel as Label

func show_overlay(result: bool, transit_time: int, amount_spent_tiles: int) -> void:
	if result:
		header_label.text = "WIN"
	else:
		header_label.text = "LOSS"
	
	time_label.text = str(transit_time)
	tile_label.text = str(amount_spent_tiles)
	
	
