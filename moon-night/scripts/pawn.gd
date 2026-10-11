
extends Enemy
class_name Pawn

#TODO: make it so that enemies bounce when they hit eachother




func choose_move() -> Vector2i:
	var forward_tile: Vector2i = grid_position + stored_dir

	# Reverse if the tile ahead is outside the map.
	if test_room.tile_map.get_cell_source_id(forward_tile) == -1:
		reverse_direction()
		forward_tile = grid_position + stored_dir

	# Always check the player in the current direction,
	# including immediately after reversing.
	if forward_tile == MainControl.player.grid_position:
		return Vector2i.ZERO

	# Check for a diagonal attack.
	var player_direction := check_for_player()
	if player_direction != Vector2i.ZERO:
		return player_direction

	return stored_dir

func check_for_player() -> Vector2i:
	# Rotate forward 90 degrees to get left and right
	var left_dir := Vector2i(stored_dir.y, -stored_dir.x)
	var right_dir := Vector2i(-stored_dir.y, stored_dir.x)

	var left_tile := grid_position + stored_dir + left_dir

	if left_tile == MainControl.player.grid_position:
		return stored_dir + left_dir

	var right_tile := grid_position + stored_dir + right_dir

	if right_tile == MainControl.player.grid_position:
		return stored_dir + right_dir

	return Vector2i.ZERO
