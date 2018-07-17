extends "res://Pieces/Piece.gd"

func get_name():
	return str(white) + "KNIGHT"

func set_material(material):
	$bKnightL_base.set_surface_material(0, material)
	$bKnightL_head.set_surface_material(0, material)

func get_material():
	return $bKnightL_base.get_surface_material(0)
	
func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	append_move(moveList, x + 1, y + 2)
	append_move(moveList, x - 1, y + 2)
	append_move(moveList, x + 1, y - 2)
	append_move(moveList, x - 1, y - 2)
	append_move(moveList, x + 2, y + 1)
	append_move(moveList, x - 2, y + 1)
	append_move(moveList, x + 2, y - 1)
	append_move(moveList, x - 2, y - 1)
	return moveList