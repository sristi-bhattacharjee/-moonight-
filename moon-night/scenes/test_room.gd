extends Node2D

@onready var label: Label = $ColorRect/Label
@onready var my_node: Node = $"game over"
@onready var button: CheckButton = $CheckButton
var switch = false
	
@onready var camera_2d: Camera2D = $Camera2D
@onready var player: Node2D = $Player
@export var turns_till_enemies_move : int = 1
var gameover = false

var player_turns = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainControl.player = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steps_left = MainControl.max_turns - MainControl.turns
	var readout = "Steps Remaining: %s" % steps_left
	label.text = readout
	
	camera_2d.position.y = player.position.y
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

#button -> game over

func _on_check_button_pressed() -> void:
	if switch:
		my_node.hide()
		switch = false
	else:
		my_node.show()
		switch = true
	

func countDown():
	player_turns += 1
	if player_turns == turns_till_enemies_move:
		move_enemies()
		player_turns = 0

func move_enemies():
	for kid in get_children():
		if kid is Enemy:
			if (kid.move()):
				gameover = true
				switch = false
				_on_check_button_pressed()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
