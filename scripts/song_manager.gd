extends Node2D
class_name SongManager

var score : int = 0
var accuracy : float = 100.0
var combo : int = 0
var best_combo : int = 0
var combo_multiplier : int = 1

var notes_hit : int
var notes_missed : int = 0
var bombs_hit : int = 0

var score_text : RichTextLabel 
var combo_text : RichTextLabel
var combo_multiplier_text : RichTextLabel

var hp : int = 100
@onready var hp_progress_bar : TextureProgressBar = %"Song UI".find_child("Hp Progress Bar")

var exit_timer = 0
@onready var exit_progress_bar : TextureProgressBar = %"Song UI".find_child("Exit Progress Bar")

@onready var charter : Charter = %Charter

func _ready() -> void:
	score_text = get_tree().get_first_node_in_group("score_text")
	combo_text = get_tree().get_first_node_in_group("combo_text")
	combo_multiplier_text = get_tree().get_first_node_in_group("combo_multiplier_text")
	
	score_text.text = "Score: " + str(score)
	combo_text.text = "Combo: " + str(combo)
	combo_multiplier_text.text = "x[color=blue]" + str(combo_multiplier)

func _process(delta: float) -> void:
	if Input.is_action_pressed("menu_back"):
		exit_timer += delta
	elif exit_timer > 0:
		exit_timer -= delta
		
	exit_progress_bar.value = exit_timer * 200
		
	if exit_timer >= 0.5:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func hit_note(_amount : int):
	notes_hit += 1
	score += _amount * combo_multiplier
	_handle_combo()
	_change_hp(2.5)
	#_calculate_accuracy()
	
func hit_bomb():
	bombs_hit += 1
	break_combo()
	
func miss_note():
	notes_missed += 1
	break_combo()
	_change_hp(-5)
	
func break_combo():
	combo = 0
	combo_multiplier = 1
	score_text.text = "Score: " + str(score)
	combo_text.text = "combo: " + str(combo)
	_handle_combo_multiplier_text()
	
func _change_hp(_value : int):
	hp += _value
	hp_progress_bar.value = hp
	
	if hp > 100:
		hp = 100
		
	if hp <= 0:
		_die()
		
func _calculate_accuracy():
	var _remaining_notes = charter.map.notes.size() - charter.map.notes[charter.note_index].size()
	for note in charter.map.notes:
		pass

func _die():
	globals.set_results(score, accuracy, best_combo, notes_hit, bombs_hit, notes_missed, false)
	get_tree().change_scene_to_file("res://scenes/result_screen.tscn")

func _handle_combo():
	combo += 1
	
	if combo > best_combo:
		best_combo = combo
	
	score_text.text = "Score: " + str(score)
	combo_text.text = "combo: " + str(combo)
	
	match combo:
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
			combo_multiplier_text.text = "x[color=cyan]" + str(combo_multiplier)
		2:
			combo_multiplier_text.text = "x[color=orange]" + str(combo_multiplier)
		3:
			combo_multiplier_text.text = "x[color=green]" + str(combo_multiplier)
		4:
			combo_multiplier_text.text = "x[color=purple]" + str(combo_multiplier)
