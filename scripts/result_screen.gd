extends Control

@onready var rank_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Rank Text"
@onready var accuracy_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Accuracy Text"
@onready var score_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Score Text"
@onready var best_combo_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Best Combo Text"
@onready var notes_hit_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Notes Hit Text"
@onready var bombs_hit_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Bombs Hit Text"
@onready var notes_missed_text : RichTextLabel = $"VBoxContainer3/VBoxContainer2/Notes Missed Text"

@onready var album_cover : TextureRect = %"Album Cover"
@onready var result_text : RichTextLabel = $"VBoxContainer3/Result Text"

func _ready() -> void:
	rank_text.text = "Rank: " + str(globals.cm_rank)
	accuracy_text.text = "Accuracy: " + str(globals.cm_accuracy)
	score_text.text = "Score: " + str(globals.cm_score)
	best_combo_text.text = "Best Combo: " + str(globals.cm_best_combo)
	notes_hit_text.text = "Notes Hit: " + str(globals.cm_notes_hit)
	bombs_hit_text.text = "Bombs Hit: " + str(globals.cm_bombs_hit)
	notes_missed_text.text = "Notes Missed: " + str(globals.cm_notes_missed)
	
	album_cover.texture = globals.current_map.album_cover
	
	if globals.cm_passed:
		result_text.text = "[color=green]You passed"
		db.send_score()
	else:
		result_text.text = "[color=red]You failed"

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
