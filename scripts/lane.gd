extends Node2D

@export var hit_key : String
@export var input_value : String
@onready var sprite : Sprite2D = %"Hit Window Sprite"
@onready var input_text : RichTextLabel = %"Input Text"

@onready var hit_score_animation_player : AnimationPlayer = %"Hit Score Animation Player"
@onready var hit_score_text : RichTextLabel = %"Hit Score Text"

enum note_score_states
{
	None,
	Perfect,
	Good,
	Okay,
}

var note_score_state : note_score_states = note_score_states.None

var colliding_note : Area2D

func _ready() -> void:
	input_text.text = input_value

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(hit_key):
		pass #Animate
	
	if Input.is_action_just_pressed(hit_key):
		match note_score_state:
			note_score_states.Perfect:
				_hit_note()
				hit_score_text.text = "Perfect!"
			note_score_states.Good:
				_hit_note()
				hit_score_text.text = "Good!"
			note_score_states.Okay:
				_hit_note()
				hit_score_text.text = "OK."
			note_score_states.None:
				_play_hit_score_animation()
				hit_score_text.text = "Miss."

func _hit_note():
	colliding_note.get_parent().queue_free()
	colliding_note = null
	_play_hit_score_animation()
	
func _play_hit_score_animation():
	hit_score_animation_player.stop()
	hit_score_animation_player.play("hit_score")

func _on_hit_window_area_entered(area: Area2D) -> void:
	if area.is_in_group("perfect"):
		note_score_state = note_score_states.Perfect
		colliding_note = area
	
	if area.is_in_group("good"):
		if note_score_state != note_score_states.Perfect:
			note_score_state = note_score_states.Good
			colliding_note = area
	
	if area.is_in_group("okay"):
		if note_score_state != note_score_states.Perfect and note_score_state != note_score_states.Good:
			note_score_state = note_score_states.Okay
			colliding_note = area

func _on_hit_window_area_exited(area: Area2D) -> void:
	if area.is_in_group("perfect"):
		note_score_state = note_score_states.None
	
	if area.is_in_group("good"):
		note_score_state = note_score_states.None
	
	if area.is_in_group("okay"):
		note_score_state = note_score_states.None
	
	colliding_note = null
