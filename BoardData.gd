extends Node

signal promotion(x, y)

var whiteNext = true
var castleWA = true
var castleWH = true
var castleBA = true
var castleBH = true
var enPassant = [-1,-1]
var position = []
var turnCount = 1
var halfTurnsFifty = 0
const START_POSITION = ["rnbqkbnr","pppppppp","11111111","11111111","11111111","11111111","PPPPPPPP","RNBQKBNR"]

func _init():
	position = START_POSITION

# x and y are the current position
# newX and newY are the target position
# this will destroy piece that is at the target
func move(x, y, newX, newY):
	position[newY][newX] = position[y][x]
	position[y][x] = '1'

	# add en passant flag
	# castle
	# do en passant
	pawn_promotion()
	whiteNext = !whiteNext
	if whiteNext:
		turnCount += 1
	halfTurnsFifty += 1
	print(position)
	return position

func pawn_promotion():
	for i in 8:
		if whiteNext:
			if get_piece_at(i, 7) == "P":
				emit_signal("promotion", i, 7)
		else:
			if get_piece_at(i, 0) == "P":
				emit_signal("promotion", i, 0)

func reset_game():
	position = START_POSITION
	return position

func is_valid_move(x, y, newX, newY):
	# Don't go off the board
	if !bounds(x) or !bounds(y) or !bounds(newX) or !bounds(newY):
		print("Out of bounds")
		return false
	# A move must be made
	if x == newX and y == newY:
		print("No move detected")
		return false
	
	var piece = get_piece_at(x,y)
	# Don't move nothing
	if piece == '1':
		print("No piece detected")
		return false
	# Don't move opponent's pieces
	if piece.to_upper() == piece and !whiteNext:
		print("Not white's turn")
		return false
	elif piece.to_upper() != piece and whiteNext:
		print("Not black's turn")
		return false
	
	# Pieces need to move a certain way
	var moves = get_piece_moves(piece, x, y)
	if !([newX, newY] in moves):
		print("Piece doesn't move that way")
		return false
	
	# Check king protection after move
	# Check king protection during castle
	return true

# Given x y coordinates, return the letter at that position
func get_piece_at(x, y):
	if !bounds(x) or !bounds(y):
		return '0'
	return position[7-y][x]

# given a piece node, return the letter at that position
func get_piece_id(piece):
	return get_piece_at(piece.position[0], piece.position[1])

# piece is the letter id of the piece (r for black rook, B for white bishop etc), x and y are the position of that piece
func get_piece_moves(piece, x, y):
	piece = piece.to_lower()
	var moveList = []
	match piece:
		"r", "q":
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
			continue
		"b", "q":
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
		"n":
			append_move(moveList, x + 1, y + 2)
			append_move(moveList, x - 1, y + 2)
			append_move(moveList, x + 1, y - 2)
			append_move(moveList, x - 1, y - 2)
			append_move(moveList, x + 2, y + 1)
			append_move(moveList, x - 2, y + 1)
			append_move(moveList, x + 2, y - 1)
			append_move(moveList, x - 2, y - 1)
		"k":
			append_move(moveList, x + 1, y + 0)
			append_move(moveList, x - 1, y + 0)
			append_move(moveList, x + 0, y + 1)
			append_move(moveList, x + 0, y - 1)
			append_move(moveList, x + 1, y + 1)
			append_move(moveList, x - 1, y + 1)
			append_move(moveList, x + 1, y - 1)
			append_move(moveList, x - 1, y - 1)
			if whiteNext:
				if castleWA:
					if get_piece_at(x - 1, y) == '1' and get_piece_at(x - 2, y) == '1':
						append_move(moveList, x - 2, y)
				if castleWH:
					if get_piece_at(x + 1, y) == '1' and get_piece_at(x + 2, y) == '1':
						append_move(moveList, x + 2, y)
			else:
				if castleBA:
					if get_piece_at(x - 1, y) == '1' and get_piece_at(x - 2, y) == '1':
						append_move(moveList, x - 2, y)
				if castleBH:
					if get_piece_at(x + 1, y) == '1' and get_piece_at(x + 2, y) == '1':
						append_move(moveList, x + 2, y)
		"p":
			if whiteNext:
				var d1 = get_piece_at(x + 1, y + 1)
				if (d1 != '1' and d1.to_lower() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
					append_move(moveList, x + 1, y + 1)
				d1 = get_piece_at(x - 1, y + 1)
				if (d1 != '1' and d1.to_lower() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
					append_move(moveList, x - 1, y + 1)
				if get_piece_at(x, y + 1) == '1':
					append_move(moveList, x, y + 1)
				else:
					continue
				if y == 1 and get_piece_at(x, y + 2) == '1':
					append_move(moveList, x, y + 2)
			else:
				var d1 = get_piece_at(x + 1, y - 1)
				if (d1 != '1' and d1.to_upper() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
					append_move(moveList, x + 1, y - 1)
				d1 = get_piece_at(x - 1, y - 1)
				if (d1 != '1' and d1.to_upper() == d1) or (d1 == '1' and x == enPassant[0] and y == enPassant[1]):
					append_move(moveList, x - 1, y - 1)
				if get_piece_at(x, y - 1) == '1':
					append_move(moveList, x, y - 1)
				else:
					continue
				if y == 6 and get_piece_at(x, y - 2) == '1':
					append_move(moveList, x, y - 2)
	return moveList

# Append a move if possible, and return true if no more moves after can be made
func append_move(list, x, y):
	if !bounds(x): return true
	if !bounds(y): return true
	print(str(x), str(y))
	var piece = get_piece_at(x, y)
	if piece != '1':
		if piece.to_upper() == piece and whiteNext:
			return true
		elif piece.to_lower() == piece and !whiteNext:
			return true
	list.append([x, y])
	if piece != '1':
		return true
	return false

func bounds(x):
	if x < 0 or x > 7:
		return false
	else:
		return true