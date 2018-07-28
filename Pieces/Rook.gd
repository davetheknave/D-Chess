extends "res://Pieces/Piece.gd"

signal move(A)

var moved = false

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

func move(x, y):
	if not moved:
		moved = true
		if position[0] == 0:
			emit_signal("move", true)
		else:
			emit_signal("move", false)
	.move(x, y)

func castle(A):
	if position[0] == 0 and A:
		board.move(self, position[0] + 3, position[1])
	elif position[0] == 7 and !A:
		board.move(self, position[0] - 2, position[1])