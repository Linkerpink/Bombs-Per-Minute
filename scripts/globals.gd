extends Node

var current_map : Map
var cm_rank : String = "SS"
var cm_score : int
var cm_best_combo : int
var cm_accuracy : float
var cm_notes_hit : int
var cm_bombs_hit : int
var cm_notes_missed : int

func set_results(_score, _acc : float, _best_combo : int, _notes_hit : int, _bombs_hit : int, _notes_missed : int):
	cm_score = _score
	cm_accuracy = _acc
	cm_best_combo = _best_combo
	cm_notes_hit = _notes_hit
	cm_bombs_hit = _bombs_hit
	cm_notes_missed = _notes_missed
