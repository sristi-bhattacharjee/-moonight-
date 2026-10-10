extends Character

var moved = false
func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return

	#Player only moves once when pressing a key, you can't hold the key down or spam it
	if event is InputEventKey and event.echo:
		return

	if not event.is_pressed():
		return

	var moved := false

	if event.is_action_pressed("ui_up", false):
		moved = try_move(Vector2i.UP)
	elif event.is_action_pressed("ui_down", false):
		moved = try_move(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left", false):
		moved = try_move(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right", false):
		moved = try_move(Vector2i.RIGHT)

	if moved:
		test_room.countDown()
		MainControl.turns += 1
