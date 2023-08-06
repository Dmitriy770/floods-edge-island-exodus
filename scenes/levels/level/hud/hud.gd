class_name HUD
extends CanvasLayer

signal tool_changed(tool: Tools)

enum Tools {CURSOR, BLOCK}

@onready var cursor := %Cursor as Button
@onready var food_bar := %FoodBar as ProgressBar
@onready var block_amount_label := %BlockAmountLabel as Label

func _ready() -> void:
	cursor.grab_focus()
	
	food_bar.value = 100

func _on_cursor_toggled(_button_pressed: bool) -> void:
	tool_changed.emit(Tools.CURSOR)

func _on_block_toggled(_button_pressed: bool) -> void:
	tool_changed.emit(Tools.BLOCK)

func update_food_bar(new_value: float) -> void:
	food_bar.value = new_value

func set_max_food(amount: float) -> void:
	food_bar.max_value = amount

func update_block_amount_label(new_value: int) -> void:
	block_amount_label.text = str(new_value)
