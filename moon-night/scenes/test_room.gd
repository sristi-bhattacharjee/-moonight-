extends Node2D

@onready var label: Label = $ColorRect/Label
@onready var my_node: Node = $"game over"
@onready var button: CheckButton = $CheckButton
var switch = false
@onready var tile_map: TileMapLayer = $TileMap
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


func move_enemies() -> void:
	var enemies: Array[Enemy] = []

	for kid in get_children():
		if kid is Enemy:
			enemies.append(kid)

	# Plan everyones moves first
	var plans: Dictionary = {}

	for enemy in enemies:
		var direction: Vector2i = enemy.choose_move()
		var destination: Vector2i = enemy.grid_position + direction

		if destination == MainControl.player.grid_position:
			gameover = true
			switch = false
			_on_check_button_pressed()
			return

		
		if tile_map.get_cell_source_id(destination) == -1:
			continue

		plans[enemy] = destination

	#Don't move if you'll both end up in the same spot
	var rejected: Dictionary = {}

	for enemy in plans:
		var destination: Vector2i = plans[enemy]

		for other in plans:
			if other != enemy and plans[other] == destination:
				rejected[enemy] = true
				rejected[other] = true

	#Don't move into other people's spots
	var changed := true

	while changed:
		changed = false

		for enemy in plans:
			if rejected.has(enemy):
				continue

			var destination: Vector2i = plans[enemy]

			for other in enemies:
				if other == enemy:
					continue

				if other.grid_position != destination:
					continue

				# If someone is in the other spot, they have to have a plan on where to go next OR ELSE
				if not plans.has(other) or rejected.has(other):
					rejected[enemy] = true
					changed = true
					break

	# Move everyone's position finally
	var accepted: Dictionary = {}

	for enemy in plans:
		if not rejected.has(enemy):
			accepted[enemy] = plans[enemy]

	for enemy in accepted:
		enemy.grid_position = accepted[enemy]

	# Animate it all at once
	for enemy in accepted:
		enemy.animate_to_current_tile()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
