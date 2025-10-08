extends Node

var users : Array[String] = ["Guest"]
var current_user : String

var current_map : Map
var cm_rank : String = "SS"
var cm_score : int
var cm_best_combo : int
var cm_accuracy : float
var cm_notes_hit : int
var cm_bombs_hit : int
var cm_notes_missed : int

var cm_passed : bool = false

func _ready() -> void:
	current_user = users[0]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func add_user(_user : String):
	users.append(_user)

func set_results(_score, _acc : float, _best_combo : int, _notes_hit : int, _bombs_hit : int, _notes_missed : int, _passed : bool):
	cm_score = _score
	cm_accuracy = _acc
	cm_best_combo = _best_combo
	cm_notes_hit = _notes_hit
	cm_bombs_hit = _bombs_hit
	cm_notes_missed = _notes_missed
	cm_passed = _passed
