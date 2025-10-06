extends Node2D

var current_map

@onready var create_map = %"Create Map"
@onready var edit_map = %"Edit Map"

func _ready() -> void:
	create_map.hide()
	edit_map.hide()

func _on_create_map_button_pressed() -> void:
	create_map.show()
	edit_map.hide()

func _on_edit_map_button_pressed() -> void:
	edit_map.show()
	create_map.hide()

func _on_create_map_file_selected(path: String) -> void:
	print("created file: " + str(path))

func _on_edit_map_file_selected(path: String) -> void:
	print("opened file: " + str(path))
