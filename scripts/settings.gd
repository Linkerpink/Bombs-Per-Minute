extends Control
class_name Settings

var settings_dict : Dictionary

var fullscreen : bool = true
var resolution : Vector2 = Vector2(1920,1080)
var framerate_cap : int = 0
var map_path : String = "user://"

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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		change_fullscreen()

func _update_settings():
	# Update Settings
	map_path_text.text = str(map_path)
	fullscreen_button.button_pressed = fullscreen
	
	DisplayServer.window_set_size(resolution)
	resolution_x_spinbox.value = resolution.x
	resolution_y_spinbox.value = resolution.y
	
	Engine.max_fps = framerate_cap
	framerate_cap_spinbox.value = framerate_cap
	
	
	save_settings()
	
func save_settings():
	settings_dict = {
		"fullscreen": fullscreen,
		"resolution_x": resolution.x,
		"resolution_y": resolution.y,
		"framerate_cap": framerate_cap,
		"map_path": map_path
	}
	
	var settings_file = FileAccess.open("user://settings.sav", FileAccess.WRITE)
	var json_string = JSON.stringify(settings_dict, "\t")
	settings_file.store_string(json_string)
	settings_file.close()

func load_settings():
	if not FileAccess.file_exists("user://settings.sav"):
		return
		
	var save_file = FileAccess.open("user://settings.sav", FileAccess.READ)
	var json_string = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
		
	settings_dict = json.data
	
	fullscreen = settings_dict["fullscreen"]
	resolution = Vector2(settings_dict["resolution_x"], settings_dict["resolution_y"])
	framerate_cap = settings_dict["framerate_cap"]
	map_path = settings_dict["map_path"]
	
	_update_settings()
	print(settings_dict)

func show_settings_menu():
	settings_menu.show()

func change_fullscreen():
	fullscreen = !fullscreen
	if not fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_timer_timeout() -> void:
	if FileAccess.file_exists("user://settings.sav"):
		load_settings()
	else:
		_update_settings()

func _on_close_button_pressed() -> void:
	settings_menu.hide()

func _on_framerate_cap_spinbox_value_changed(value: float) -> void:
	framerate_cap = value

func _on_map_editor_button_pressed() -> void:
	set_map_folder_window.show()

func _on_set_map_folder_dir_selected(dir: String) -> void:
	map_path = dir

func _on_resolution_x_spinbox_value_changed(value: float) -> void:
	resolution.x = value

func _on_resolution_y_spinbox_value_changed(value: float) -> void:
	resolution.y = value

func _on_fullscreen_button_pressed() -> void:
	fullscreen = !fullscreen
