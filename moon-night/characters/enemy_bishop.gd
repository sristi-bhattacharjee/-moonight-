
extends Enemy

var diagonal_directions: Array[Vector2i] = [
	Vector2i(-1, 1),  # Down-left
	Vector2i(1, 1),   # Down-right
	Vector2i(1, -1),  # Up-right
	Vector2i(-1, -1)  # Up-left
]

var direction_index: int = 0

func choose_move() -> Vector2i:
	var direction: Vector2i = diagonal_directions[direction_index]
	var distance: int = randi_range(2, 4)

	# Cycle to the next diagonal for the next move.
	direction_index = (direction_index + 1) % diagonal_directions.size()

	var destination: Vector2i = grid_position

	for i in range(distance):
		var next_tile: Vector2i = destination + direction

		# Stop if the next tile is outside the map.
		if tile_map.get_cell_source_id(next_tile) == -1:
			break

		# Stop if the player is on the next tile.
		if next_tile == MainControl.player.grid_position:
			destination = next_tile
			break

		# Stop if another enemy blocks the way.
		var blocked := false
		for kid in test_room.get_children():
			if kid is Enemy and kid != self:
				if kid.grid_position == next_tile:
					blocked = true
					break

		if blocked:
			break

		destination = next_tile

	# Return the displacement, not the absolute destination.
	return destination - grid_position


#TODO: Add all enemies
#add all graphics
#add better mechanics (like werewolf?)
#add sfx and music
#fix bugs/improve collision
