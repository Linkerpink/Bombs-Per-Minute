extends Resource
class_name Map

@export var name : String = "Map Name"
@export var audio : AudioStream
@export var album_cover : Texture2D
@export var bpm : float = 120
@export var measures : int
@export var scroll_speed : float = 10
@export var notes : Array[Dictionary] = [
	{ "lane": 0, "measure": 0, "beat": 1, "subdivision": 0, "end_beat": 0 , "end_subdivision": 0.0, "type": "note" },
]
