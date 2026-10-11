
extends Enemy

#TODO: make it so that enemies bounce when they hit eachother

func choose_move() -> Vector2i:
	var player_direction := check_for_player()

	if player_direction != Vector2i.ZERO:
		return player_direction
	if test_room.tile_map.get_cell_source_id(grid_position + stored_dir) == -1:
		reverse_direction()
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
