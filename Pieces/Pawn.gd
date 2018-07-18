extends "res://Pieces/Piece.gd"

var moved = false

func _ready():
	pass

func get_moves(board):
	var moveList = []
	var x = position[0]
	var y = position[1]
	# Captures
	for m in get_diagonals(board, x, y):
		var p = board.get_piece_at(m[0], m[1])
		if p != null and p.white != white or (p == null and x == board.enPassant[0] and y == board.enPassant[1]):
			append_move(moveList, m[0], m[1])
	# Normal move
	for m in get_forwards(board, x, y):
		var p = board.get_piece_at(m[0], m[1])
		if p != null:
			break
		append_move(moveList, m[0], m[1])
	return moveList

func get_diagonals(board, x, y):
	var diags = []
	if white:
		diags.append([x - 1, y + 1])
		diags.append([x + 1, y + 1])
	else:
		diags.append([x - 1, y - 1])
		diags.append([x + 1, y - 1])
	return diags

func get_forwards(board, x, y):
	var forwards = []
	if white:
		forwards.append([x, y + 1])
		if not moved:
			forwards.append([x, y + 2])
	else:
		forwards.append([x, y - 1])
		if not moved:
			forwards.append([x, y - 2])
	return forwards

func move(x, y):
	.move(x, y)
	moved = true
	if (white and y == 7) or (not white and y == 0):
		board.promote(self)

func get_name():
	return str(white) + "PAWN"