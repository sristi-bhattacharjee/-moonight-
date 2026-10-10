extends Node2D

var keydown = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		global_position += Vector2(-32,0)
	elif Input.is_action_just_pressed("ui_right") :
		global_position += Vector2(32,0)
	elif Input.is_action_just_pressed("ui_up") :
		global_position += Vector2(0,-32)
	elif Input.is_action_just_pressed("ui_down"):
		global_position += Vector2(0,32)
