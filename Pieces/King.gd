extends "res://Pieces/Piece.gd"

signal castle(A)

var castleA = true
var castleH = true

func init(board, white):
	self.board = board
	self.white = white

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
	if castleA and \
	board.get_piece_at(x - 1, y) == null and \
	board.get_piece_at(x - 2, y) == null and \
	board.get_piece_at(x - 3, y) == null:
		append_move(moveList, x - 2, y)
	if castleH and \
	board.get_piece_at(x + 1, y) == null and \
	board.get_piece_at(x + 2, y) == null:
		append_move(moveList, x + 2, y)
	return moveList

func time_flip(turns):
	return null

func move(x, y):
	castleA = false
	castleH = false
	if x == position[0] - 2:
		emit_signal("castle", true)
	if x == position[0] + 2:
		emit_signal("castle", false)
	.move(x, y)

func castle_block(A):
	if A:
		castleA = false
	else:
		castleH = false