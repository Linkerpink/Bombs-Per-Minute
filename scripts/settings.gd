extends Control

var fullscreen : bool = true
var resolution : Vector2
var framerate_cap : int = 0
var map_path : String = ""

@onready var settings_menu = $"Settings Menu"
@onready var timer = $Timer

@onready var fullscreen_button = %"Fullscreen Button"

@onready var resolution_x_spinbox : SpinBox = %"Resolution X Spinbox"
@onready var resolution_y_spinbox : SpinBox = %"Resolution Y Spinbox"

@onready var framerate_cap_spinbox = %"Framerate Cap Spinbox"
@onready var map_path_text = %"Map Path Text"

@onready var set_map_folder_window : FileDialog = %"Set Map Folder"

func _ready() -> void:
	settings_menu.hide()

func _update_settings():
	map_path_text.text = str(map_path)
	fullscreen_button.button_pressed = fullscreen
	Engine.max_fps = framerate_cap
	framerate_cap_spinbox.value = framerate_cap
	
func show_settings_menu():
	settings_menu.show()

func change_fullscreen():
	fullscreen = !fullscreen
	if not fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	_update_settings()

func _on_timer_timeout() -> void:
	_update_settings()

func _on_close_button_pressed() -> void:
	settings_menu.hide()

func _on_framerate_cap_spinbox_value_changed(value: float) -> void:
	framerate_cap = value
	_update_settings()

func _on_map_editor_button_pressed() -> void:
	set_map_folder_window.show()

func _on_set_map_folder_dir_selected(dir: String) -> void:
	map_path = dir
	_update_settings()
