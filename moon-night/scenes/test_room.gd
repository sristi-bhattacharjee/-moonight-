extends Node2D

@onready var label: Label = $ColorRect/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steps_left = MainControl.max_turns - MainControl.turns
	var readout = "Steps Remaining: %s" % steps_left
	label.text = readout
