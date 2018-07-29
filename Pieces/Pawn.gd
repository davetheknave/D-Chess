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
		if p != null and p.white != white:
			if p.alice == alice:
				append_move(moveList, m[0], m[1])
		if p == null and m[0] == board.enPassant[0] and m[1] == board.enPassant[1]:
			if white:
				p = board.get_piece_at(m[0], m[1] - 1)
			else:
				p = board.get_piece_at(m[0], m[1] + 1)
			if p != null and p.alice == alice:
				append_move(moveList, m[0], m[1])
	# Normal move
	for m in get_forwards(board, x, y):
		var p = board.get_piece_at(m[0], m[1])
		if p != null and p.alice == alice:
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
	var oldX = position[0]
	var oldY = position[1]
	moved = true
	if (white and y == 7) or (not white and y == 0):
		board.promote(self)
	if board.enPassant[0] == x and board.enPassant[1] == y:
		board.enPassant(self)
	.move(x, y)
	if oldY - 2 == y:  # Black double move
		board.enPassant[0] = x
		board.enPassant[1] = y + 1
	if oldY + 2 == y:  # White double move
		board.enPassant[0] = x
		board.enPassant[1] = y - 1