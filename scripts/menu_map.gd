extends Button

@export var map : Map
@onready var song_text = $"Song Text"
var main_menu

func _ready() -> void:
	main_menu = get_tree().get_first_node_in_group("main_menu")

func _on_pressed() -> void:
	main_menu.set_selected_map(map)

func _on_timer_timeout() -> void:
	song_text.text = map.name
