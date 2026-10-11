extends Enemy
class_name RookEnemy

@export var max_move_distance: int = 3

func choose_move() -> Vector2i:
	var player_direction := check_for_player()
	var target = stored_dir
	if player_direction != Vector2i.ZERO:
		target = player_direction
	else:
		var clear_distance := 0
		for distance in range(1, 4):
			var check_tile := grid_position + (stored_dir * distance)
			
			# Stop before obstacles or player
			if not valid_tile(check_tile) or check_tile == MainControl.player.grid_position:
				break
				
			clear_distance = distance

		target = stored_dir * clear_distance
			
		
	if valid_tile(target) == false:
		reverse_direction()

	return target

func valid_tile(tile: Vector2i) -> bool:
	if test_room.tile_map.get_cell_source_id(tile) == -1:
		return false
	return true

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
