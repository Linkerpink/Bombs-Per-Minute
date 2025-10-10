extends Node2D

@onready var choose_map_dir = %"Choose Map Dir"
@onready var edit_map = %"Edit Map"

@onready var start_menu : Control = $"Map Editor UI/Start Menu"
@onready var create_map_menu : Control = $"Map Editor UI/Create Map Menu"

var current_map
# nm = new map
var nm_name : String = "Map Name"
var nm_artist : String = "Artist"
var nm_mapper : String = "Mapper"
var nm_description : String = "Description"
var nm_album_cover : Texture2D = preload("res://assets/sprites/bomb.png")
@onready var album_cover : TextureRect = %"Album Cover"
@onready var choose_cover_window : FileDialog = %"Choose Cover"
var nm_audio : AudioStream = preload("res://assets/audio/Vine Boom sound effect meme.mp3")
@onready var choose_audio_window : FileDialog = %"Choose Audio"
@onready var audio_name_text : RichTextLabel = %"Audio Name Text"
var nm_bpm : float = 120
var nm_time_signature : Vector2 = Vector2(4,4)
var nm_subdivision_size : int = 4
var nm_scroll_speed : float = 10
@onready var set_map_folder : FileDialog = %"Set Map Folder"
var nm_directory : String = "user://maps.map"
var nm_notes : Array[Dictionary] = [
	{ "lane": 0, "measure": 0, "beat": 1, "subdivision": 0, "end_beat": 0 , "end_subdivision": 0.0, "type": "note" },
]


func _ready() -> void:
	start_menu.show()
	create_map_menu.hide()
	
	choose_map_dir.hide()
	edit_map.hide()


func _on_choose_map_dir_button_pressed() -> void:
	pass

func _on_edit_map_button_pressed() -> void:
	edit_map.show()
	choose_map_dir.hide()

func _on_choose_map_dir_file_selected(path: String) -> void:
	pass

func _on_edit_map_file_selected(path: String) -> void:
	print("opened file: " + str(path))

func _on_create_map_button_pressed() -> void:
	start_menu.hide()
	create_map_menu.show()


# Map name
func _on_enter_map_name_text_changed(new_text: String) -> void:
	nm_name = new_text

# Artist
func _on_enter_artist_name_text_changed(new_text: String) -> void:
	nm_artist = new_text

# Mapper
func _on_enter_mapper_name_text_changed(new_text: String) -> void:
	nm_mapper = new_text

# Description
func _on_enter_description_text_changed(new_text: String) -> void:
	nm_description = new_text

# Cover
func _on_choose_cover_button_pressed() -> void:
	choose_cover_window.show()

func _on_choose_cover_file_selected(path: String) -> void:
	var _image = Image.new()
	_image.load(path)
	
	var _image_texture = ImageTexture.new()
	_image_texture.set_image(_image)
	
	album_cover.texture = _image_texture

# Audio
func _on_choose_audio_button_pressed() -> void:
	choose_audio_window.show()

func _on_choose_audio_file_selected(path: String) -> void:
	var _audio : AudioStream = AudioStream.new()
	_audio = load(path)
	nm_audio = _audio
	
	audio_name_text.text = path.get_file()

# BPM
func _on_enter_bpm_value_changed(value: float) -> void:
	nm_bpm = value

# Time signature
func _on_enter_measure_value_changed(value: float) -> void:
	nm_time_signature.x = value

func _on_enter_beat_value_changed(value: float) -> void:
	nm_time_signature.y = value

# Scroll Speed
func _on_enter_scroll_speed_value_changed(value: float) -> void:
	nm_scroll_speed = value

# Map Folder
func _on_change_path_button_pressed() -> void:
	set_map_folder.show()

func _on_set_map_folder_dir_selected(dir: String) -> void:
	nm_directory = dir


func _on_start_editing_button_pressed() -> void:
	var _nm_map_dict = {
		"name" : nm_name,
		"artist" : nm_artist,
		"mapper" : nm_mapper,
		"description" : nm_description,
		"album_cover" : nm_album_cover,
		"audio" : nm_audio,
		"bpm" : nm_bpm,
		"time_signature_x" : nm_time_signature.x,
		"time_signature_y" : nm_time_signature.y,
		"subdivision_size" : nm_subdivision_size,
		"scroll_speed" : nm_scroll_speed,
		"notes" : nm_notes,
		"directory" : nm_directory,
	}

	var _map_file = FileAccess.open("user://map.map", FileAccess.WRITE)
	var json_string = JSON.stringify(_nm_map_dict, "\t")
	_map_file.store_string(json_string)
	_map_file.close()
