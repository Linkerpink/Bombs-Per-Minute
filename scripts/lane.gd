extends Node2D

@export var hit_key : String
@export var input_value : String
@onready var sprite : Sprite2D = %"Hit Window Sprite"
@onready var input_text : RichTextLabel = %"Input Text"

@onready var hit_score_animation_player : AnimationPlayer = %"Hit Score Animation Player"
@onready var hit_score_text : RichTextLabel = %"Hit Score Text"

@onready var hit_effect_animation_player : AnimationPlayer = %"Hit Effect Animation Player"

@onready var song_manager : SongManager = %"Song Manager"
@onready var beat_indicator_scene : PackedScene = preload("res://scenes/beat_indicator.tscn")

enum note_score_states
{
	None,
	Perfect,
	Good,
	Okay,
	Bomb,
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
				_hit_note(300)
				hit_score_text.text = "[color=purple]Perfect!"
			note_score_states.Good:
				_hit_note(200)
				hit_score_text.text = "[color=green]Good!"
			note_score_states.Okay:
				_hit_note(100)
				hit_score_text.text = "[color=orange]OK."
			note_score_states.Bomb:
				_hit_bomb()
				hit_score_text.text = "[shake][color=red]KABOOM!"
			note_score_states.None:
				_miss_note()
				hit_score_text.text = "[color=red]Miss."

func _hit_note(_amount : int): 
	print("hit noted")
	colliding_note.get_parent().get_parent().queue_free()
	colliding_note = null
	_play_hit_score_animation()
	song_manager.hit_note(_amount)
	hit_effect_animation_player.stop()
	hit_effect_animation_player.play("hit_effect")

func _miss_note():
	_play_hit_score_animation()
	song_manager.miss_note()

func _hit_bomb():
	print("hit_bomb")
	song_manager.hit_bomb()
	colliding_note.get_parent().queue_free()
	_play_hit_score_animation()
	colliding_note = null
	
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
	
	if area.is_in_group("bomb"):
		note_score_state = note_score_states.Bomb
		colliding_note = area

func _on_hit_window_area_exited(area: Area2D) -> void:
	if area.is_in_group("perfect"):
		note_score_state = note_score_states.None
	
	if area.is_in_group("good"):
		note_score_state = note_score_states.None
	
	if area.is_in_group("okay"):
		note_score_state = note_score_states.None
		
	if area.is_in_group("bomb"):
		note_score_state = note_score_states.None
	
	colliding_note = null

func _on_conductor_beat(position: Variant) -> void:
	pass
	#var _beat_indicator = beat_indicator_scene.instantiate()
	#add_child(_beat_indicator)

func _on_miss_trigger_area_exited(area: Area2D) -> void:
	if area.is_in_group("okay"):
		area.queue_free()
		note_score_state = note_score_states.None
		hit_score_text.text = "[color=red]Miss."
		_miss_note()
		
	if area.is_in_group("bomb"):
		area.queue_free()
