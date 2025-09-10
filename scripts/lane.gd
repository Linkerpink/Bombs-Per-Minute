extends Node2D

@export var hit_key : String
@export var input_value : String
@onready var sprite : Sprite2D = %"Hit Window Sprite"
@onready var input_text : RichTextLabel = %"Input Text"
@export var normal_opacity = 0.75
var animating : bool = false

func _ready() -> void:
	sprite.self_modulate.a = normal_opacity
	input_text.text = input_value

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(hit_key):
		sprite.self_modulate.a = 1.0
		animating = true
		
	if animating:
		sprite.self_modulate.a = lerp(sprite.self_modulate.a, normal_opacity, 10.0 * delta)
