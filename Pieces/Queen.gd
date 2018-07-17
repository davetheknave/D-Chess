extends "res://Pieces/Piece.gd"

func get_name():
	return str(white) + "QUEEN"

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	# Rook-like moves
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
	# Bishop-like moves
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