extends AudioStreamPlayer
class_name Conductor

#region Variables
var song_bpm : int # The beats per minute in the song
var song_measures : int # The amount of measures in a beat. For a 4/4 time signature, this would be 4
var song_scroll_speed : float
@export var song_audio : AudioStream
@onready var charter = %Charter

var song_position = 0.0
var song_position_in_beats = 1
var seconds_per_beat
var last_reported_beat = 0
var beats_before_start = 0
var current_measure = 0

var closest = 0
var time_off_beat = 0.0

@onready var start_timer : Timer = $"Start Timer"

signal beat(position)
signal measure(position)

@onready var song_position_in_beats_text : RichTextLabel = $"../Song UI/MarginContainer/Debug UI/Song Position In Beats Text"
@onready var current_measure_text : RichTextLabel = $"../Song UI/MarginContainer/Debug UI/Current Measure Text"

@onready var song_manager : SongManager = %"Song Manager"
#endregion

func _ready() -> void:
	globals.set_results(0,0,0,0,0,0)
	song_bpm = charter.map.bpm
	song_measures = charter.map.measures
	song_scroll_speed = charter.map.scroll_speed
	seconds_per_beat = 60.0 / song_bpm
	stream = charter.map.audio
	if song_audio != null:
		stream = song_audio
	else:
		push_error("No song audio selected for this song!")
	
func _physics_process(delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / seconds_per_beat)) + beats_before_start
		_report_beat()
		_update_ui()
	if not playing and song_position_in_beats > 1:
		var sm = song_manager
		globals.set_results(sm.score, sm.accuracy, sm.best_combo, sm.notes_hit, sm.bombs_hit, sm.notes_missed)
		get_tree().change_scene_to_file("res://scenes/result_screen.tscn")

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if current_measure > song_measures - 1:
			current_measure = 0
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", current_measure)
		last_reported_beat = song_position_in_beats
		current_measure += 1

func note_to_time(measure: int, beat: int, subdivision: int, bpm: float, beats_per_measure: int, subdivision_size: int):
	var seconds_per_beat = 60.0 / bpm
	var total_beats = measure * beats_per_measure + beat + (float(subdivision) / subdivision_size)
	return total_beats * seconds_per_beat

func play_with_beat_offset(_num):
	beats_before_start = _num
	start_timer.wait_time = seconds_per_beat
	start_timer.start()

func play_from_beat(_beat, _offset):
	play()
	seek(_beat * seconds_per_beat)
	beats_before_start = _offset
	current_measure = _beat % song_measures

func _on_beat(position: Variant) -> void:
	#print("beat")
	pass

func _on_measure(position: Variant) -> void:
	#print(current_measure)
	pass

func _on_start_timer_timeout() -> void:
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		start_timer.start()
	elif song_position_in_beats == beats_before_start -1:
		start_timer.wait_time = start_timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		start_timer.start()
	else:
		#play_from_beat(8,0)
		play()
		start_timer.stop()
	_report_beat()
	
func _update_ui():
	song_position_in_beats_text.text = "Song position in beats: " + str(song_position_in_beats)
	current_measure_text.text = "Current measure: " + str(current_measure)
	pass
