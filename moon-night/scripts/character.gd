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
	snap_to_grid()


func snap_to_grid() -> void:
	global_position = tile_map.to_global(
		tile_map.map_to_local(grid_position)
	)




func try_move(direction: Vector2i) -> bool:
	var target_tile: Vector2i = grid_position + direction

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
