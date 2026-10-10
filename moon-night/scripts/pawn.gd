extends Enemy

func move():
	var player_position = check_for_player()
	if player_position:
		try_move(player_position)
	else:
		try_move(Vector2i.DOWN)
	
func check_for_player() -> Vector2i:
	var target_tile: Vector2i = grid_position + Vector2i.DOWN + Vector2i.LEFT



	# Don't move into an empty cell.
	if tile_map.get_cell_source_id(target_tile) == -1:
		return(false)

	grid_position = target_tile
	is_moving = true

	var target_position: Vector2 = tile_map.to_global(
		tile_map.map_to_local(grid_position)
	)

	var tween := create_tween()
	tween.tween_property(self, "global_position", target_position, 0.15)
	tween.tween_callback(func(): is_moving = false)
	return(true)
