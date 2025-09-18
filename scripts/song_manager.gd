extends Node2D
class_name SongManager

var score : int = 0
var streak : int = 0
var combo_multiplier : int = 1

var notes_missed : int = 0
var bombs_hit : int = 0

var score_text : RichTextLabel 
var streak_text : RichTextLabel
var combo_multiplier_text : RichTextLabel

func _ready() -> void:
	score_text = get_tree().get_first_node_in_group("score_text")
	streak_text = get_tree().get_first_node_in_group("streak_text")
	combo_multiplier_text = get_tree().get_first_node_in_group("combo_multiplier_text")
	
	score_text.text = "Score: " + str(score)
	streak_text.text = "Streak: " + str(streak)
	combo_multiplier_text.text = "x[color=blue]" + str(combo_multiplier)

func hit_note():
	score += 300 * combo_multiplier
	_handle_streak()
	
func hit_bomb():
	bombs_hit += 1
	break_combo()
	
func miss_note():
	notes_missed += 1
	break_combo()
	
func break_combo():
	streak = 0
	combo_multiplier = 1
	score_text.text = "Score: " + str(score)
	streak_text.text = "Streak: " + str(streak)
	_handle_combo_multiplier_text()

func _handle_streak():
	streak += 1
	
	score_text.text = "Score: " + str(score)
	streak_text.text = "Streak: " + str(streak)
	
	match streak:
		0:
			combo_multiplier = 1
			_handle_combo_multiplier_text()
		10:
			combo_multiplier = 2
			_handle_combo_multiplier_text()
		20:
			combo_multiplier = 3
			_handle_combo_multiplier_text()
		30:
			combo_multiplier = 4
			_handle_combo_multiplier_text()

func _handle_combo_multiplier_text():
	match combo_multiplier:
		1:
			combo_multiplier_text.text = "x[color=blue]" + str(combo_multiplier)
		2:
			combo_multiplier_text.text = "x[color=orange]" + str(combo_multiplier)
		3:
			combo_multiplier_text.text = "x[color=green]" + str(combo_multiplier)
		4:
			combo_multiplier_text.text = "x[color=purple]" + str(combo_multiplier)
