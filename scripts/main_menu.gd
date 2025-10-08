extends Control
class_name MainMenu

@onready var main_menu_ui : Control = %"Main Menu UI"
@onready var song_select_ui : Control = %"Song Select UI"

var selected_map : Map
@onready var album_cover : TextureRect = %"Album Cover"
@onready var name_text : RichTextLabel = %"Name Text"

@onready var menu_maps = %"Menu Maps"
@onready var menu_map_scene : PackedScene = preload("res://scenes/menu_map.tscn")
@export var all_maps : Array[Map]

@onready var main_scene : PackedScene = preload("res://scenes/main.tscn")
@onready var map_editor_scene : PackedScene = preload("res://scenes/map_editor.tscn")

@onready var warning_message : Control = %"Warning Message"
@onready var warning_header : RichTextLabel = $"Main Menu UI/Warning Message/VBoxContainer2/Header"
@onready var warning_subtext : RichTextLabel = $"Main Menu UI/Warning Message/VBoxContainer2/Subtext"

@onready var warning_tutorial_texture_rect : TextureRect = $"Main Menu UI/Warning Message/PanelContainer/Tutorial TextureRect"

@onready var warning_tutorial_no_user_selected_texture : Texture2D = preload("res://assets/sprites/no user selected tutorial.jpg")

var new_username : String = ""

@onready var user_selection_window : FoldableContainer = %"User Selection Window"
@onready var user_holder : VBoxContainer = %"User Holder"
@onready var user_button : PackedScene = preload("res://scenes/user_button.tscn")
@onready var current_user_text : RichTextLabel = %"Current User Text"

@onready var settings = %Settings

var typing : bool = false

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
	set_current_user_text()
	_update_users_window()

func set_menu_state(_state : MenuStates):
	user_selection_window.fold()
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
		
func set_current_user_text():
	current_user_text.text = "Current User: " + str(globals.current_user)

func _on_start_song_button_pressed() -> void:
	globals.current_map = selected_map
	get_tree().change_scene_to_packed(main_scene)

func _on_enter_username_text_changed(new_text: String) -> void:
	new_username = new_text

func _on_add_user_button_pressed() -> void:
	globals.add_user(new_username)
	_update_users_window()
	
func _update_users_window():
	for i in user_holder.get_children():
		i.queue_free()
	
	for i in globals.users:
		var _ub = user_button.instantiate()
		_ub._change_user_button_text(globals.users[globals.users.find(i)])
		user_holder.add_child(_ub)

func _on_close_button_pressed() -> void:
	warning_message.hide()

func _on_enter_username_editing_toggled(toggled_on: bool) -> void:
	typing = toggled_on

func _on_start_button_pressed() -> void:
	if menu_state == MenuStates.Main:
		if globals.users.size() > 0:
			if settings.map_path != "":
				set_menu_state(MenuStates.SongSelect)
			else:
				warning_message.show()
				warning_header.text = "[shake level=15][color=red]No Map Path Selected!"
				warning_subtext.text = "Go to settings, go to [wave][color=green]Set Map Path [/color][/wave]to set the map path"
				warning_tutorial_texture_rect.texture = warning_tutorial_no_user_selected_texture
		else:
			warning_message.show()
			warning_header.text = "[shake level=15][color=red]No User Selected!"
			warning_subtext.text = "Enter a username and click [wave][color=green]+ Add User [/color][/wave]to make a new user"
			warning_tutorial_texture_rect.texture = warning_tutorial_no_user_selected_texture

func _on_back_button_pressed() -> void:
	if menu_state == MenuStates.SongSelect:
		set_menu_state(MenuStates.Main)

func _on_map_editor_button_pressed() -> void:
	get_tree().change_scene_to_packed(map_editor_scene)

func _on_settings_button_pressed() -> void:
	settings.show_settings_menu()
