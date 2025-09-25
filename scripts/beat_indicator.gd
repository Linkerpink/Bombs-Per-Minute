extends Sprite2D

var conductor : Conductor
var scroll_speed : float
var hit_time : float = 0.0
var type : String = "note"
var end_beat : int = 0
var end_subdivision : int = 0

func _ready() -> void:
	conductor = get_tree().get_first_node_in_group("conductor")
	scroll_speed = conductor.song_scroll_speed
	hit_time = conductor.song_position

func _process(delta: float) -> void:
	if conductor == null:
		push_error("conductor not found in note!")
	var time_until_hit = hit_time - conductor.song_position
	position.y = 200 - time_until_hit * scroll_speed
