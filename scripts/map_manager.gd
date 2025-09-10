extends Node

@export var map : Map
@export var lanes : Array[Node2D] = []
var song_time : float = 0.0

var map_name : String = "Map Name"
var map_audio : AudioStream
var map_bpm : float = 120
var map_time_signature : Dictionary # For example 4/4 would be: Key = 4, Value = 4. Both are ints
var map_scroll_speed : float = 10
var map_notes : Dictionary # Key (int) = lane, Value(float) = time Notes defined as (measure, beat, subdivision)


func _ready() -> void:
	_load_map()
	
func _load_map():
	map_name = map.name
	map_audio = map.audio
	map_bpm = map.bpm
	map_time_signature = map.time_signature
	map_scroll_speed = map.scroll_speed
	map_notes = map.notes
	
func _process(delta: float) -> void:
	song_time += beat_to_seconds(map_bpm,4,4,0,0) * delta
	#print(song_time)

func beat_to_seconds(_bpm : float, _beats_per_measure : int, _measure_index, _beat_index : int, _subdivision : float = 0):
	var _seconds_per_beat = 60 / _bpm
	var _total_beats = (_measure_index * _beats_per_measure) + _beat_index + _subdivision
	return _total_beats * _seconds_per_beat
