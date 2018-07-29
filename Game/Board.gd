extends Spatial

export (PackedScene) var king
export (PackedScene) var queen
export (PackedScene) var bishop
export (PackedScene) var pawn
export (PackedScene) var rook
export (PackedScene) var knight

signal promote(piece)
signal turn(white)
signal select(piece)
signal release(name)

const squareLength = 0.5
const origin = Vector3(-0.99, 0.43, -0.445)
const START_POSITION = ["rnbqkbnr","pppppppp","11111111","11111111","11111111","11111111","PPPPPPPP","RNBQKBNR"]

var squares  # A representation of the board
var whiteNext  # Is it white's turn?
var enPassant  # If a piece moves 2 spaces, this keeps track of the en passant position
var turnCount = 0


# Getting ready

func _ready():
	for i in $White.get_children():
		attach_square(i, true)
	for i in $Black.get_children():
		attach_square(i, false)
	reset()

func reset():
	if squares != null:
		for i in squares:
			for j in i:
				if j != null:
					j.delete()
	squares = []
	whiteNext = true
	enPassant = [-1,-1]
	for i in 8:
		squares.append([null,null,null,null,null,null,null,null])
		for j in 8:
			var white
			var piece
			if START_POSITION[i][j].to_lower() == START_POSITION[i][j]:
				white = true
			else:
				white = false
			match START_POSITION[i][j].to_lower():
				'k': piece = king.instance()
				'q': piece = queen.instance()
				'n': piece = knight.instance()
				'p': piece = pawn.instance()
				'b': piece = bishop.instance()
				'r': piece = rook.instance()
			if piece == null:
				continue
			piece.init(self, white)
			add_child(piece)
			piece.alice = false
			if piece.other != null:
				connect("turn", piece.other, "turn")
			piece.update_material()
			move(piece, j, i)
			if "moved" in piece:
				piece.moved = false
	var wKing = squares[0][4]
	var wRookA = squares[0][0]
	var wRookH = squares[0][7]
	var bKing = squares[7][4]
	var bRookA = squares[7][0]
	var bRookH = squares[7][7]
	wRookA.connect("move", wKing, "castle_block")
	wRookH.connect("move", wKing, "castle_block")
	wKing.connect("castle", wRookA, "castle")
	wKing.connect("castle", wRookH, "castle")
	bRookA.connect("move", bKing, "castle_block")
	bRookH.connect("move", bKing, "castle_block")
	bKing.connect("castle", bRookA, "castle")
	bKing.connect("castle", bRookH, "castle")

func attach_square(square, white):
	square.create_convex_collision()
	var body = square.get_node(square.name+"_col")
	body.collision_layer = 2


# Piece Moving

func move(piece, x, y):
	if piece.position != null:
		# Capture any pieces
		if squares[y][x] != null:
			squares[y][x].delete()
			turnCount = 0
		# Update board array
		squares[piece.position[1]][piece.position[0]] = null
		# Tell piece to move, and do anything else
		piece.move(x, y)
	else:
		piece.position = [x, y]
	squares[y][x] = piece
	# Update turn count
	if piece.name == "Pawn":
		turnCount = 0
	turnCount += 1
	# Update board model
	place(piece, piece.position[0], piece.position[1])

var turnsMove = -1
func try_move(piece, pos, turns):
	turnsMove = turns
	var truePos = get_numbers(pos.name)
	var x = truePos[0]
	var y = truePos[1]
	var moveValid = true
	if (piece.white and !whiteNext) or (!piece.white and whiteNext):
		print("It's not your turn, yet!")
		moveValid = false
	if not [x, y] in piece.get_moves(self):
		moveValid = false
		print("That piece doesn't move that way!")
	if not check_move(piece, x, y):
		moveValid = false
		print("You cannot move into check!")
	if piece.name == "King":
		if piece.position[0] == (x - 2):
			var checknow = get_check(piece.white)
			var checkone = !check_move(piece, x - 1, y, false)
			var checktwo = !check_move(piece, x, y)
			if checknow or checkone or checktwo:
				moveValid = false
				print("Cannot castle while threatened.")
		if piece.position[0] == (x + 2):
			if get_check(piece.white) or !check_move(piece, x + 1, y, false) or !check_move(piece, x, y):
				moveValid = false
				print("Cannot castle while threatened.")
	if moveValid:
		move(piece, x, y)
		whiteNext = !whiteNext
		if turns > 1:
			time_travel(piece, turns)
		emit_signal("turn", whiteNext)
	turnsMove = -1

func swap(old, new):
	old.deselect()
	var x = old.position[0]
	var y = old.position[1]
	new.global_transform = old.global_transform
	squares[y][x] = new

func place(piece, x, y):
	piece.translation = Vector3(origin.x + squareLength * x, origin.y, origin.z - squareLength * y)


# Evaluation

func get_state():
	var whiteCheck = get_check(true)
	var whiteHasMoves = has_valid_moves(true)
	var blackCheck = get_check(false)
	var blackHasMoves = has_valid_moves(false)
	if whiteNext:
		if !whiteHasMoves:
			if whiteCheck: return States.GameState.WHITECHECKMATE
			else: return States.GameState.STALEMATE
	else:
		if !blackHasMoves:
			if blackCheck: return States.GameState.BLACKCHECKMATE
			else: return States.GameState.STALEMATE
	if whiteCheck: return States.GameState.WHITECHECK
	elif blackCheck: return States.GameState.BLACKCHECK
	else: return States.GameState.NORMAL

func get_check(white):
	for row in squares:
		for piece in row:
			if piece != null and piece.white != white:
				var moves = piece.get_moves(self)
				for move in moves:
					var pieceAtMove = get_piece_at(move[0], move[1])
					if pieceAtMove != null and pieceAtMove.name == "King":
						return true
	return false

func check_move(piece, x, y, alice=true, normal=true):
	var result = true
	# Temporary swap
	var oldTarget = squares[y][x]
	squares[piece.position[1]][piece.position[0]] = null
	squares[y][x] = piece
	piece.alice = !piece.alice
	# Check test
	if alice:
		if get_check(piece.white):
			result = false
	if normal and piece.name == "King":
		piece.alice = !piece.alice
		if get_check(piece.white):
			result = false
		piece.alice = !piece.alice
	# Swap back
	squares[piece.position[1]][piece.position[0]] = piece
	squares[y][x] = oldTarget
	piece.alice = !piece.alice
	return result

func has_valid_moves(white):
	for row in squares:
		for piece in row:
			if piece != null and piece.white == white:
				var moves = piece.get_moves(self)
				for move in moves:
					if check_move(piece, move[0], move[1]):
						return true
	return false


# Special Rules

func promote(piece):
	emit_signal("promote", piece)

func finish_promotion(oldPawn, newPiece):
	var x = oldPawn.position[0]
	var y = oldPawn.position[1]
	var piece
	match newPiece:
		'q': piece = queen.instance()
		'n': piece = knight.instance()
		'b': piece = bishop.instance()
		'r': piece = rook.instance()
	add_child(piece)
	piece.white = oldPawn.white
	piece.alice = oldPawn.alice
	piece.board = self
	piece.update_material()
	move(piece, x, y)
	oldPawn.delete()
	squares[y][x] = piece

func enPassant(piece):
	if squares[enPassant[1]][enPassant[0]] == null:
		var target = get_enPassant()
		if target == null:
			return
		if target.alice == piece.alice:
			target.delete()

func get_enPassant():
	if enPassant != [-1, -1]:
		if enPassant[1] == 5:
			return squares[4][enPassant[0]]
		if enPassant[1] == 2:
			return squares[3][enPassant[0]]
	return null


func time_travel(piece, turns):
	var tile = piece.time_flip(turns)
	if tile != null:
		swap(piece, tile)

# Cosmetic

func deselect_all():
	for i in squares:
		for j in i:
			if j == null:
				continue
			j.deselect()


# Fetching

func get_piece_at(x, y):
	if !bounds(x) or !bounds(y):
		return null
	return squares[y][x]

func get_piece_on(square):
	var truePos = get_numbers(square.name)
	var x = truePos[0]
	var y = truePos[1]
	return get_piece_at(x, y)


# Other

func get_numbers(pos):
	var numbers = []
	match pos[0]:
		"A": numbers.append(1)
		"B": numbers.append(2)
		"C": numbers.append(3)
		"D": numbers.append(4)
		"E": numbers.append(5)
		"F": numbers.append(6)
		"G": numbers.append(7)
		"H": numbers.append(8)
	numbers.append(int(pos[1]))
	numbers[0] = 8 - numbers[0]
	numbers[1] = 8 - numbers[1]
	return numbers

func bounds(n):
	if n < 0 or n > 7:
		return false
	else:
		return true