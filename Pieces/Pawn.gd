extends "res://Pieces/Piece.gd"

func _ready():
	pass

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
#	if board.whiteNext:
#		var d1 = get_piece_at(x + 1, y + 1)
#		if (d1 != '1' and d1.to_lower() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
#			append_move(moveList, x + 1, y + 1)
#		d1 = get_piece_at(x - 1, y + 1)
#		if (d1 != '1' and d1.to_lower() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
#			append_move(moveList, x - 1, y + 1)
#		if get_piece_at(x, y + 1) == '1':
#			append_move(moveList, x, y + 1)
#		else:
#			continue
#		if y == 1 and get_piece_at(x, y + 2) == '1':
#			append_move(moveList, x, y + 2)
#	else:
#		var d1 = get_piece_at(x + 1, y - 1)
#		if (d1 != '1' and d1.to_upper() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
#			append_move(moveList, x + 1, y - 1)
#		d1 = get_piece_at(x - 1, y - 1)
#		if (d1 != '1' and d1.to_upper() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
#			append_move(moveList, x - 1, y - 1)
#		if get_piece_at(x, y - 1) == '1':
#			append_move(moveList, x, y - 1)
#		else:
#			continue
#		if y == 6 and get_piece_at(x, y - 2) == '1':
#			append_move(moveList, x, y - 2)
	return moveList

func get_name():
	return str(white) + "PAWN"