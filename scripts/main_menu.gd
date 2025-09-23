extends Control

@onready var main_menu_ui : Control = %"Main Menu UI"
@onready var song_select_ui : Control = %"Song Select UI"

var selected_map : Map
@onready var album_cover : TextureRect = %"Album Cover"
@onready var name_text : RichTextLabel = %"Name Text"

@onready var menu_maps = %"Menu Maps"
@onready var menu_map_scene : PackedScene = preload("res://scenes/menu_map.tscn")
@export var all_maps : Array[Map]

@onready var main_scene : PackedScene = preload("res://scenes/main.tscn")

enum MenuStates
{
	Main,
	SongSelect
}

var menu_state : MenuStates

func _ready() -> void:
	set_menu_state(MenuStates.Main)
	_load_maps()
	_choose_random_map()

func _process(delta: float) -> void:
	match menu_state:
		MenuStates.Main:
			if Input.is_action_just_pressed("menu_select"):
				set_menu_state(MenuStates.SongSelect)
		MenuStates.SongSelect:
			if Input.is_action_just_pressed("menu_back"):
				set_menu_state(MenuStates.Main)

func set_menu_state(_state : MenuStates):
	menu_state = _state
	
	match menu_state:
		MenuStates.Main:
			main_menu_ui.show()
			song_select_ui.hide()
		MenuStates.SongSelect:
			song_select_ui.show()
			main_menu_ui.hide()
			
func set_selected_map(_map : Map):
	album_cover.texture = _map.album_cover
	name_text.text = _map.name
	selected_map = _map
	
func _choose_random_map():
	var _rnd = randi_range(0, all_maps.size() - 1)
	set_selected_map(all_maps[_rnd])

func _load_maps():
	for m in all_maps:
		var _map = menu_map_scene.instantiate()
		menu_maps.add_child(_map)
		_map.map = m

func _on_start_song_button_pressed() -> void:
	globals.current_map = selected_map
	get_tree().change_scene_to_packed(main_scene)
