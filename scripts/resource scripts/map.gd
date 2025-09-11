extends Resource
class_name Map

@export var name : String = "Map Name"
@export var audio : AudioStream
@export var bpm : float = 120
@export var measures : int
@export var scroll_speed : float = 10
@export var notes : Dictionary # Key (int) = lane, Value(float) = time Notes defined as (measure, beat, subdivision)
