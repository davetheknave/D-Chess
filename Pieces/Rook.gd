extends "res://Pieces/Piece.gd"

func get_name():
	return str(white) + "ROOK"

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	for i in range(x+1, 8):
		if append_move(moveList, i, y):
			break
	for i in range(y+1, 8):
		if append_move(moveList, x, i):
			break
	for i in range(x-1, -1, -1):
		if append_move(moveList, i, y):
			break
	for i in range(y-1, -1, -1):
		if append_move(moveList, x, i):
			break
	return moveList