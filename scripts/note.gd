extends Node2D

var conductor : Conductor
var scroll_speed : float
var hit_time : float = 0.0
var type : String = "note"
var end_beat : int = 0
var end_subdivision : int = 0

@onready var normal : Node2D = %Normal
@onready var bomb : Node2D = %Bomb
@onready var setup_timer : Timer = %"Setup Timer"
@onready var end_point : Node2D = %"End Point"
@onready var line : Line2D = %Line2D

signal hit_note

func _ready() -> void:
	conductor = get_tree().get_first_node_in_group("conductor")
	scroll_speed = conductor.song_scroll_speed

func _process(delta: float) -> void:
	if conductor == null:
		push_error("conductor not found in note!")
	var time_until_hit = hit_time - conductor.song_position
	position.y = 200 - time_until_hit * scroll_speed
	
	#if type == "long":
		#line.set_point_position(1,end_point.position)

func _on_setup_timer_timeout() -> void:
	#if (end_beat > 0):
		#type = "long"
	
	match type:
		"note":
			normal.show()
			bomb.queue_free()
		"bomb":
			bomb.show()
			normal.queue_free()
		#"long":
			#normal.show()
			#bomb.queue_free()
			#line.add_point(end_point.position)
