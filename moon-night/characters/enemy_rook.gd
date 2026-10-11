extends Enemy
class_name RookEnemy

var directions: Array[Vector2i] = [
	Vector2i.LEFT, 
	Vector2i.DOWN,  
	Vector2i.RIGHT, 
	Vector2i.UP  
]

@onready var direction_index: int = current_direction


func choose_move() -> Vector2i:
	var direction: Vector2i = directions[direction_index]
	var distance: int = randi_range(2, 4)

	direction_index = (direction_index + 1) % directions.size()

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

	return destination - grid_position
