
extends Enemy

func choose_move() -> Vector2i:
	var player_direction := check_for_player()

	if player_direction != Vector2i.ZERO:
		return player_direction

	return Vector2i.DOWN


func check_for_player() -> Vector2i:
	var target_tile: Vector2i = grid_position + Vector2i.DOWN + Vector2i.LEFT
	if target_tile == MainControl.player.grid_position:
		return Vector2i(-1, 1)

	target_tile = grid_position + Vector2i.DOWN + Vector2i.RIGHT
	if target_tile == MainControl.player.grid_position:
		return Vector2i(1, 1)

	return Vector2i.ZERO
