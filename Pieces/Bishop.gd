extends "res://Pieces/Piece.gd"

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	var nx = x
	var ny = y
	while true:
		nx += 1
		ny += 1
		if append_move(moveList, nx, ny):
			break
	nx = x
	ny = y
	while true:
		nx += 1
		ny -= 1
		if append_move(moveList, nx, ny):
			break
	nx = x
	ny = y
	while true:
		nx -= 1
		ny += 1
		if append_move(moveList, nx, ny):
			break
	nx = x
	ny = y
	while true:
		nx -= 1
		ny -= 1
		if append_move(moveList, nx, ny):
			break
	return moveList