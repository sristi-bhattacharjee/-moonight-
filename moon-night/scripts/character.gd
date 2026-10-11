extends Node2D
class_name Character
@onready var test_room: Node2D = $".."


@onready var tile_map: TileMapLayer = $"../TileMap"
var grid_position: Vector2i
var is_moving: bool = false

func _ready() -> void:
	grid_position = tile_map.local_to_map(
		tile_map.to_local(global_position)
	)
	snap_to_grid() #add victory screen, fix blurriness


func snap_to_grid() -> void:
	global_position = tile_map.to_global(
		tile_map.map_to_local(grid_position)
	)




func try_move(direction: Vector2i) -> bool:
	var target_tile: Vector2i = grid_position + direction

	# Don't move into an empty cell.
	if tile_map.get_cell_source_id(target_tile) == -1:
		return(false)
	for kid in test_room.get_children():
		if kid is Enemy:
			if target_tile == kid.grid_position:
				if kid is Vampire:
					test_room.display_victory()
					break
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

func move_to_tile(target_tile: Vector2i) -> void:
	grid_position = target_tile
	is_moving = true

	var target_position := tile_map.to_global(
		tile_map.map_to_local(target_tile)
	)

	var tween := create_tween()
	tween.tween_property(
		self, "global_position", target_position, 0.15
	)
	tween.tween_callback(func(): is_moving = false)

func animate_to_current_tile() -> void:
	is_moving = true

	var target_position := tile_map.to_global(
		tile_map.map_to_local(grid_position)
	)

	var tween := create_tween()
	tween.tween_property(
		self, "global_position", target_position, 0.15
	)
	tween.tween_callback(func(): is_moving = false)

func get_surrounding_tiles():
	var surrounding_tiles =[]
	var target_tile
	for y in 3:
		for x in 3:
			target_tile = grid_position + Vector2i(x - 1, y - 1)
			if grid_position == target_tile:
				continue
			surrounding_tiles.append(target_tile)
	return surrounding_tiles
