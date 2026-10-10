extends Enemy

func move() -> bool:
	var player_position = check_for_player()
	if player_position != Vector2i(0,0):
		try_move(player_position)
		return(true)
	else:
		try_move(Vector2i.DOWN)
		return(false)
	
	
func check_for_player() -> Vector2i:
	var target_tile: Vector2i = grid_position + Vector2i.DOWN + Vector2i.LEFT
	if target_tile == MainControl.player.grid_position:
		return (Vector2i(-1,1))
		
	target_tile = grid_position + Vector2i.DOWN + Vector2i.RIGHT
	if target_tile == MainControl.player.grid_position:
		return (Vector2i(1,1))
	return (Vector2i(0,0))
