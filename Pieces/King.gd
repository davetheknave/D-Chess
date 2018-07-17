extends "res://Pieces/Piece.gd"

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	append_move(moveList, x + 1, y + 0)
	append_move(moveList, x - 1, y + 0)
	append_move(moveList, x + 0, y + 1)
	append_move(moveList, x + 0, y - 1)
	append_move(moveList, x + 1, y + 1)
	append_move(moveList, x - 1, y + 1)
	append_move(moveList, x + 1, y - 1)
	append_move(moveList, x - 1, y - 1)
	# Castling
#	if whiteNext:
#		if castleWA:
#			if get_piece_at(x - 1, y) == '1' and get_piece_at(x - 2, y) == '1':
#				append_move(moveList, x - 2, y)
#		if castleWH:
#			if get_piece_at(x + 1, y) == '1' and get_piece_at(x + 2, y) == '1':
#				append_move(moveList, x + 2, y)
#	else:
#		if castleBA:
#			if get_piece_at(x - 1, y) == '1' and get_piece_at(x - 2, y) == '1':
#				append_move(moveList, x - 2, y)
#		if castleBH:
#			if get_piece_at(x + 1, y) == '1' and get_piece_at(x + 2, y) == '1':
#				append_move(moveList, x + 2, y)
	return moveList

func get_name():
	return str(white) + "KING"