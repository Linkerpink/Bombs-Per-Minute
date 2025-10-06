extends Node

var fullscreen : bool = true

var users : Array[String]
var current_user : String

var current_map : Map
var cm_rank : String = "SS"
var cm_score : int
var cm_best_combo : int
var cm_accuracy : float
var cm_notes_hit : int
var cm_bombs_hit : int
var cm_notes_missed : int

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		change_fullscreen()
		
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func change_fullscreen():
	fullscreen = !fullscreen
	if not fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func add_user(_user : String):
	print("added user")
	users.append(_user)

func set_results(_score, _acc : float, _best_combo : int, _notes_hit : int, _bombs_hit : int, _notes_missed : int):
	cm_score = _score
	cm_accuracy = _acc
	cm_best_combo = _best_combo
	cm_notes_hit = _notes_hit
	cm_bombs_hit = _bombs_hit
	cm_notes_missed = _notes_missed
