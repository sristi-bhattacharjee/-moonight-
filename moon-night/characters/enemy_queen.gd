extends Enemy
class_name QueenEnemy

@export_range(0, 7) var starting_index: int = 0
@export var min_distance: int = 2
@export var max_distance: int = 4

# Counterclockwise in screen space 
const DIRECTIONS: Array[Vector2i] = [
	Vector2i(-1,  0),  
	Vector2i(-1,  1), 
	Vector2i( 0,  1), 
	Vector2i( 1,  1), 
	Vector2i( 1,  0),  
	Vector2i( 1, -1),  
	Vector2i( 0, -1),
	Vector2i(-1, -1), 
]

var direction_index: int = 0

func _ready() -> void:
	super._ready()
	direction_index = starting_index % DIRECTIONS.size()


func choose_move() -> Vector2i:
	var direction: Vector2i = DIRECTIONS[direction_index]
	var distance: int = randi_range(min_distance, max_distance)

	direction_index = (direction_index + 1) % DIRECTIONS.size()

	var destination: Vector2i = grid_position

	for i in range(distance):
		var next_tile: Vector2i = destination + direction

		if tile_map.get_cell_source_id(next_tile) == -1:
			break

		if next_tile == MainControl.player.grid_position:
			destination = next_tile
			break

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
