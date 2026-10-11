
extends Character

var shift := false

func _process(_delta: float) -> void:
	shift = Input.is_key_pressed(KEY_SHIFT)
	print(shift)

func _unhandled_input(event: InputEvent) -> void:
	if MainControl.frozen:
		return
	if is_moving:
		return

	if not event.is_pressed() or (event is InputEventKey and event.echo):
		return

	if not (
		event.is_action("ui_up") or event.is_action("ui_down")
		or event.is_action("ui_left") or event.is_action("ui_right")
	):
		return

	var dir := Vector2i.ZERO

	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1

	if shift:
		if abs(dir.x) == 1 and abs(dir.y) == 1:
			attempt_move(dir)
		return

	if abs(dir.x) + abs(dir.y) == 1:
		attempt_move(dir)


func attempt_move(direction: Vector2i) -> void:
	if try_move(direction):
		test_room.countDown()
		MainControl.turns += 1
