extends Enemy

func move() -> bool:
	var rand = randi_range(1,5)
	if rand == 1:
		try_move(Vector2i.DOWN)
	elif rand == 2:
		try_move(Vector2i.UP)
	elif rand == 3:
		try_move(Vector2i.LEFT)
	elif rand == 4:
		try_move(Vector2i.RIGHT)
	return (false)
	
func check_for_player() -> bool:
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
