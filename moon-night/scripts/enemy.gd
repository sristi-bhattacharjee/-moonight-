
extends Character
class_name Enemy

enum Direction {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

@export var current_direction: Direction = Direction.DOWN

var stored_dir: Vector2i = Vector2i.DOWN


func _ready() -> void:
	super._ready()

	match current_direction:
		Direction.DOWN:
			stored_dir = Vector2i.DOWN
		Direction.UP:
			stored_dir = Vector2i.UP
		Direction.LEFT:
			stored_dir = Vector2i.LEFT
		Direction.RIGHT:
			stored_dir = Vector2i.RIGHT


func choose_move() -> Vector2i:
	return stored_dir

func reverse_direction() -> void:
	stored_dir = -stored_dir

	match stored_dir:
		Vector2i.UP:
			current_direction = Direction.UP
		Vector2i.RIGHT:
			current_direction = Direction.RIGHT
		Vector2i.DOWN:
			current_direction = Direction.DOWN
		Vector2i.LEFT:
			current_direction = Direction.LEFT
