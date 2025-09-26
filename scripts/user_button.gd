extends Button

@export var user : String
var main_menu : MainMenu

func _ready() -> void:
	main_menu = get_tree().get_first_node_in_group("main_menu")

func _change_user_button_text(_text : String):
	user = _text
	text = user

func _on_pressed() -> void:
	globals.current_user = user
	main_menu.set_current_user_text()
