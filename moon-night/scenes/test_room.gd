extends Node2D
@onready var label: Label = $ColorRect/Label
@onready var my_node: Node = $"Camera2D/game over"
@onready var victoryScreen: Node2D = $Camera2D/Victory

@onready var button: CheckButton = $CheckButton
var switch = false
@onready var tile_map: TileMapLayer = $TileMap
@onready var camera_2d: Camera2D = $Camera2D
@onready var player: Node2D = $Player
@export var turns_till_enemies_move : int = 1
var gameover = false
var victory = true
var player_turns = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainControl.player = $Player
	MainControl.frozen = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steps_left = MainControl.max_turns - MainControl.turns
	var readout = "Steps Remaining: %s" % steps_left
	label.text = readout
	
	camera_2d.position.y = player.position.y
	camera_2d.position.x = player.position.x

#button -> game over

func _on_check_button_pressed() -> void:
	if switch:
		my_node.hide()
		switch = false
	else:
		my_node.show()
		switch = true
func display_victory() -> void:
	MainControl.frozen = true
	victoryScreen.show()

func countDown():
	player_turns += 1
	if player_turns == turns_till_enemies_move and !MainControl.frozen:
		move_enemies()
		player_turns = 0



func move_enemies() -> void:
	var enemies: Array[Enemy] = []

	for kid in get_children():
		if kid is Enemy:
			enemies.append(kid)

	var plans: Dictionary = {}
	var rejected: Dictionary = {}
	var attacker: Enemy = null
	var player_tile: Vector2i = MainControl.player.grid_position

	# Plan each enemy's move.
	for enemy in enemies:
		var direction: Vector2i = enemy.choose_move()

		if direction == Vector2i.ZERO:
			continue

		var destination: Vector2i = enemy.grid_position + direction

		if tile_map.get_cell_source_id(destination) == -1:
			continue

		# Detect attacks before resolving enemy collisions.
		if destination == player_tile:
			if enemy is Pawn:
				# Pawns can attack diagonally, but not forward.
				if abs(direction.x) != 1 or abs(direction.y) != 1:
					continue

			# The first enemy that can attack gets priority.
			if attacker == null:
				attacker = enemy
				plans[enemy] = destination
			continue

		plans[enemy] = destination

	# Resolve conflicts for ordinary moves.
	# An attacker takes priority over all ordinary moves.
	for enemy in plans:
		if enemy == attacker:
			continue

		var destination: Vector2i = plans[enemy]

		for other in plans:
			if other == enemy:
				continue
			if other == attacker:
				continue

			if plans[other] == destination:
				rejected[enemy] = true
				break

	# Reject moves into occupied enemy tiles when the occupant
	# is not moving successfully.
	var changed := true

	while changed:
		changed = false

		for enemy in plans:
			if enemy == attacker or rejected.has(enemy):
				continue

			var destination: Vector2i = plans[enemy]

			for other in enemies:
				if other == enemy:
					continue

				if other.grid_position != destination:
					continue

				# The attacker is leaving its old tile.
				if other == attacker:
					continue

				if not plans.has(other) or rejected.has(other):
					rejected[enemy] = true
					changed = true
					break

	# Accept ordinary moves.
	var accepted: Dictionary = {}

	for enemy in plans:
		if enemy == attacker:
			continue

		if not rejected.has(enemy):
			accepted[enemy] = plans[enemy]

	# Force the attacking enemy's move to be accepted.
	if attacker != null:
		accepted[attacker] = plans[attacker]

	# Update logical positions before animating.
	for enemy in accepted:
		enemy.grid_position = accepted[enemy]

	for enemy in accepted:
		enemy.animate_to_current_tile()

	# Reverse blocked pawns so they can escape deadlocks.
	for enemy in rejected:
		if enemy is Pawn:
			enemy.reverse_direction()

	# Handle game over after the attack animation.
	if attacker != null:
		await get_tree().create_timer(0.2).timeout
		gameover = true
		MainControl.frozen = true
		switch = false
		_on_check_button_pressed()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
