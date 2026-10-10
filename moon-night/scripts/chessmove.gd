class_name ChessMove
extends Resource

enum MoveType {
	MOVE_POSITION, # Move to spot (horse)
	MOVE_DIRECTION # Move in direction (rook)
}

@export var movement_type: MoveType
@export var point: Vector2i
