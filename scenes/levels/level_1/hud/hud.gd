class_name HUD
extends CanvasLayer

signal tool_changed(tool: Tools)

enum Tools {CURSOR, BLOCK}

@onready var cursor := %Cursor as Button

func _ready() -> void:
	cursor.grab_focus()

func _on_cursor_toggled(_button_pressed: bool) -> void:
	tool_changed.emit(Tools.CURSOR)

func _on_block_toggled(_button_pressed: bool) -> void:
	tool_changed.emit(Tools.BLOCK)
