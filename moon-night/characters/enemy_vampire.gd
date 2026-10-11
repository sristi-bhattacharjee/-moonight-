
extends Enemy
class_name Vampire

func choose_move() -> Vector2i:
	var player_position := check_for_player()
	var unsafe = true
	var random_dir
	while unsafe:
		random_dir = movements[randi() % movements.size()]
		if (grid_position+ random_dir) == MainControl.player.grid_position:
			unsafe = true
		elif test_room.tile_map.get_cell_source_id(grid_position + random_dir) == -1:
			unsafe = true
		else: 
			unsafe = false
	
	
	return random_dir


func check_for_player() -> Vector2i:
	var surroundings = get_surrounding_tiles()
	for tile in surroundings:
		if tile == MainControl.player.grid_position:
			return tile
	

	return Vector2i.ZERO
