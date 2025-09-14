extends Node2D

var conductor : Conductor
var scroll_speed : float
var hit_time : float = 0.0

signal hit_note

func _ready() -> void:
	conductor = get_tree().get_first_node_in_group("conductor")
	scroll_speed = conductor.song_scroll_speed

func _process(delta: float) -> void:
	if conductor == null:
		push_error("conductor not found in note!")
	var time_until_hit = hit_time - conductor.song_position
	position.y = 200 - time_until_hit * scroll_speed
