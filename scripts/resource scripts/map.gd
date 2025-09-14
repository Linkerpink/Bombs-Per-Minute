extends Resource
class_name Map

@export var name : String = "Map Name"
@export var audio : AudioStream
@export var bpm : float = 120
@export var measures : int
@export var scroll_speed : float = 10
@export var notes : Array[Dictionary] = [
	{ "lane": 0, "measure": 0, "beat": 5, "subdivision": 0 },
	{ "lane": 2, "measure": 0, "beat": 6, "subdivision": 0 },
	{ "lane": 1, "measure": 1, "beat": 7, "subdivision": 2 },
	{ "lane": 3, "measure": 1, "beat": 8, "subdivision": 0 }
]
