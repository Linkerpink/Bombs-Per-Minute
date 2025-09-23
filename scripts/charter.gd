extends Node

var map : Map
@onready var note_scene : PackedScene = preload("res://scenes/note.tscn")
@onready var conductor : Conductor = %Conductor
@export var note_spawn_ahead : float = 2.0
@onready var lanes : Array = %"Lanes Holder".get_children()

var note_index := 0
var active_notes := []

func _ready() -> void:
	map = globals.current_map
	var subdivision_size := 4
	for note in map.notes:
		note["time"] = conductor.note_to_time(
			note["measure"],
			note["beat"],
			note["subdivision"],
			map.bpm,
			map.measures,
			subdivision_size
		)

func _process(delta: float) -> void:
	if conductor.playing and note_index < map.notes.size():
		var current_time = conductor.song_position
		var next_note = map.notes[note_index]

		if current_time >= next_note["time"] - note_spawn_ahead:
			spawn_note(next_note)
			note_index += 1

func spawn_note(note_data: Dictionary):
	var note = note_scene.instantiate()
	add_child(note)

	var lane_node = lanes[note_data["lane"]]
	note.position = Vector2(lane_node.position.x, -720)

	note.set("hit_time", note_data["time"])
	note.set("type", note_data["type"])
	note.set("end_beat", note_data["end_beat"])
	note.set("end_subdivision", note_data["end_subdivision"])

	active_notes.append(note)
