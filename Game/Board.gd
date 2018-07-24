extends Spatial

export (PackedScene) var king
export (PackedScene) var queen
export (PackedScene) var bishop
export (PackedScene) var pawn
export (PackedScene) var rook
export (PackedScene) var knight

signal promote(piece)
signal turn(white)

const squareLength = 0.5
const origin = Vector3(-0.99, 0.5, -0.4)
const START_POSITION = ["rnbqkbnr","pppppppp","11111111","11111111","11111111","11111111","PPPPPPPP","RNBQKBNR"]

var squares
var currentPiece
var whiteNext
var enPassant
var turnCount = 0

signal release(name)

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
					j.queue_free()
	squares = []
	whiteNext = true
	enPassant = [-1,-1]
	currentPiece = null
	set_up_board(START_POSITION)

func set_up_board(position):
	for i in 8:
		squares.append([null,null,null,null,null,null,null,null])
		for j in 8:
			var white
			var piece
			if position[i][j].to_lower() == position[i][j]:
				white = true
			else:
				white = false
			match position[i][j].to_lower():
				'k': piece = king.instance()
				'q': piece = queen.instance()
				'n': piece = knight.instance()
				'p': piece = pawn.instance()
				'b': piece = bishop.instance()
				'r': piece = rook.instance()
			if piece == null:
				continue
			add_child(piece)
			piece.set_white(white)
			piece.alice = false
			piece.board = self
			piece.connect("selected", self, "piece_clicked")
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

func piece_clicked(piece):
	currentPiece = piece
	deselect_all()

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
	elif turnCount > 100: return States.GameState.STALEMATE
	else: return States.GameState.NORMAL

func get_check(white):
	for row in squares:
		for piece in row:
			if piece != null and piece.white != white:
				var moves = piece.get_moves(self)
				for move in moves:
					var pieceAtMove = get_piece_at(move[0], move[1])
					if pieceAtMove != null and pieceAtMove.get_name() == "KING" and pieceAtMove.white == white:
						return true
	return false

func check_move(piece, x, y, double=true):
	var result = true
	# Temporary swap
	var oldTarget = squares[y][x]
	squares[piece.position[1]][piece.position[0]] = null
	squares[y][x] = piece
	piece.alice = !piece.alice
	# Check test
	if double:
		if get_check(piece.white):
			result = false
	if piece.get_name() == "KING":
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

func promote(piece):
	emit_signal("promote", piece)

func finish_promotion(newPiece):
	var x = currentPiece.position[0]
	var y = currentPiece.position[1]
	var piece
	match newPiece:
		'q': piece = queen.instance()
		'n': piece = knight.instance()
		'b': piece = bishop.instance()
		'r': piece = rook.instance()
	add_child(piece)
	piece.set_white(currentPiece.white)
	piece.board = self
	piece.connect("selected", self, "piece_clicked")
	move(piece, x, y)
	squares[y][x] = piece
	currentPiece.queue_free()

func deselect_all():
	for i in squares:
		for j in i:
			if j == null:
				continue
			j.deselect()

func attach_square(square, white):
	square.create_convex_collision()
	var body = square.get_node(square.name+"_col")
	body.connect("input_event", self, "mouse_over", [square, white], CONNECT_DEFERRED)

func get_piece_at(x, y):
	if !bounds(x) or !bounds(y):
		return null
	return squares[y][x]

func move(piece, x, y):
	if piece.position != null:
		# Capture any pieces
		if squares[y][x] != null:
			squares[y][x].queue_free()
			turnCount = 0
		# Update board array
		squares[piece.position[1]][piece.position[0]] = null
		# Tell piece to move, and do anything else
		piece.move(x, y)
	else:
		piece.position = [x, y]
	squares[y][x] = piece
	# Update turn count
	if piece.get_name() == "PAWN":
		turnCount = 0
	turnCount += 1
	# Update board model
	piece.translation = Vector3(origin.x + squareLength * x, origin.y, origin.z - squareLength * y)

func enPassant():
	if squares[enPassant[1]][enPassant[0]] == null:
		if enPassant[1] == 5 and squares[4][enPassant[0]].alice == currentPiece.alice:
			squares[4][enPassant[0]].queue_free()
			squares[4][enPassant[0]] = null
		if enPassant[1] == 2 and squares[3][enPassant[0]].alice == currentPiece.alice:
			squares[3][enPassant[0]].queue_free()
			squares[3][enPassant[0]] = null

func mouse_over(camera, event, click_position, click_normal, shape_idx, pos, white):
	if event is InputEventMouseButton:
		if !event.pressed:
			if currentPiece != null:
				var truePosition = get_numbers(pos.name)
				try_move(currentPiece, truePosition[0], truePosition[1])

func try_move(piece, x, y):
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
	if piece.get_name() == "KING":
		if piece.position[0] == (x - 2):
			if get_check(piece.white) or !check_move(piece, x - 1, y, false) or !check_move(piece, x - 2, y):
				moveValid = false
				print("Cannot castle while threatened")
		if piece.position[0] == (x + 2):
			if get_check(piece.white) or !check_move(piece, x + 1, y, false) or !check_move(piece, x + 2, y):
				moveValid = false
				print("Cannot castle while threatened")
	if moveValid:
		move(piece, x, y)
		whiteNext = !whiteNext
		emit_signal("turn", whiteNext)

func time_travel(turns):
	if currentPiece != null and currentPiece.white == whiteNext:
		var tile = currentPiece.time_flip(turns)
		if tile != null:
			whiteNext = !whiteNext
			emit_signal("turn", whiteNext)
			connect("turn", tile, "turn")

func swap(old, new):
	old.hide()
	squares[old.position[1]][old.position[0]] = new
	new.translation = Vector3(origin.x + squareLength * old.position[0], origin.y, origin.z - squareLength * old.position[1])

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