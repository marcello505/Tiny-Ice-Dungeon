extends RayCast2D
class_name ChessPieceRayCast

func get_chess_piece_object_type(pos : Vector2)->int:
	var result = -1
	position = pos
	force_raycast_update()
	if(is_colliding()):
		var object = get_collider()
		if(object.has_method("get_piece_type")):
			result = object.get_piece_type()
	return result

func get_chess_piece_object(pos:Vector2)->ChessPiece:
	var result:ChessPiece
	position = pos
	force_raycast_update()
	if(is_colliding()):
		var object = get_collider()
		if(object.has_method("get_piece_type")):
			result = object
	return result
