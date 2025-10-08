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

@onready var resolution_option_button = %"Resolution Option Button"

@onready var framerate_cap_option_button = %"Framerate Cap Option Button"
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
	
	if resolution == Vector2(1280, 720):
		resolution_option_button.selected = 0
	if resolution == Vector2(1920, 1080):
		resolution_option_button.selected = 1
	if resolution == Vector2(2560, 1440):
		resolution_option_button.selected = 2
	if resolution == Vector2(3840, 2160):
		resolution_option_button.selected = 3
	if resolution == Vector2(640, 480):
		resolution_option_button.selected = 4
	if resolution == Vector2(800, 600):
		resolution_option_button.selected = 5
	if resolution == Vector2(1024, 768):
		resolution_option_button.selected = 6
	if resolution == Vector2(1600, 1200):
		resolution_option_button.selected = 7
		
	if framerate_cap == 30:
		framerate_cap_option_button.selected = 0
	if framerate_cap == 60:
		framerate_cap_option_button.selected = 1
	if framerate_cap == 120:
		framerate_cap_option_button.selected = 2
	if framerate_cap == 144:
		framerate_cap_option_button.selected = 3
	if framerate_cap == 165:
		framerate_cap_option_button.selected = 4
	if framerate_cap == 180:
		framerate_cap_option_button.selected = 5
	if framerate_cap == 240:
		framerate_cap_option_button.selected = 6
	if framerate_cap == 360:
		framerate_cap_option_button.selected = 7
	if framerate_cap == 480:
		framerate_cap_option_button.selected = 8
	if framerate_cap == 0:
		framerate_cap_option_button.selected = 9
	
	Engine.max_fps = framerate_cap
	
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

func _on_timer_timeout() -> void:
	resolution_option_button.add_item("1280 x 720")
	resolution_option_button.add_item("1920 x 1080")
	resolution_option_button.add_item("2560 x 1440")
	resolution_option_button.add_item("3840 x 2160")
	resolution_option_button.add_item("640 x 480")
	resolution_option_button.add_item("800 x 600")
	resolution_option_button.add_item("1024 x 768")
	resolution_option_button.add_item("1600 x 1200")
	
	framerate_cap_option_button.add_item("30")
	framerate_cap_option_button.add_item("60")
	framerate_cap_option_button.add_item("120")
	framerate_cap_option_button.add_item("144")
	framerate_cap_option_button.add_item("165")
	framerate_cap_option_button.add_item("180")
	framerate_cap_option_button.add_item("240")
	framerate_cap_option_button.add_item("360")
	framerate_cap_option_button.add_item("480")
	framerate_cap_option_button.add_item("Unlimited")
	
	if FileAccess.file_exists("user://settings.sav"):
		load_settings()
	else:
		_update_settings()

func show_settings_menu():
	settings_menu.show()

func change_fullscreen():
	fullscreen = !fullscreen
	if not fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

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

func _on_resolution_option_button_item_selected(index: int) -> void:
	if index == 0:
		resolution = Vector2(1280, 720)
	if index == 1:
		resolution = Vector2(1920, 1080)
	if index == 2:
		resolution = Vector2(2560, 1440)
	if index == 3:
		resolution = Vector2(3840, 2160)
	if index == 4:
		resolution = Vector2(640, 480)
	if index == 5:
		resolution = Vector2(800, 600)
	if index == 6:
		resolution = Vector2(1024, 768)
	if index == 7:
		resolution = Vector2(1600, 1200)

func _on_framerate_cap_option_button_item_selected(index: int) -> void:
	if index == 0:
		framerate_cap = 30
	if index == 1:
		framerate_cap = 60
	if index == 2:
		framerate_cap = 120
	if index == 3:
		framerate_cap = 144
	if index == 4:
		framerate_cap = 165
	if index == 5:
		framerate_cap = 180
	if index == 6:
		framerate_cap = 240
	if index == 7:
		framerate_cap = 360
	if index == 8:
		framerate_cap = 480
	if index == 9:
		framerate_cap = 0
