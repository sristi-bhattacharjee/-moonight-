extends Character

var moved = false

#TODO:
#add diagonal movement
#make enemies move without hitting eachother
#make rain idea?
#make vampire

func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return

	# Only respond on a fresh key press (no echo, no release)
	if not event.is_pressed() or (event is InputEventKey and event.echo):
		return

	# Only react to movement keys
	if not (
		event.is_action("ui_up") or event.is_action("ui_down")
		or event.is_action("ui_left") or event.is_action("ui_right")
	):
		return

	# Build direction from the current *live* state of all four keys
	var dir := Vector2i.ZERO
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1

	if dir == Vector2i.ZERO:
		return

	if try_move(dir):
		test_room.countDown()
		MainControl.turns += 1
