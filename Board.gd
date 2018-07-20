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

var squares = []
var currentPiece
var whiteNext = true
var enPassant = [-1,-1]

signal release(name)

func _ready():
	for i in $White.get_children():
		attach_square(i, true)
	for i in $Black.get_children():
		attach_square(i, false)
	for x in 8:
		squares.append([null,null,null,null,null,null,null,null])
	set_up_board(START_POSITION)

func set_up_board(position):
	for i in 8:
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
	var checkW = false
	var checkB = false
	for row in squares:
		for piece in row:
			if piece == null:
				continue
			var moves = piece.get_moves(self)
			for move in moves:
				var pieceAtMove = get_piece_at(move[0], move[1])
				if pieceAtMove != null and pieceAtMove.get_name() == "KING":
					if pieceAtMove.white:
						checkW = true
					else:
						checkB = true
	if checkW:
		return States.GameState.WHITECHECK
	elif checkB:
		return States.GameState.BLACKCHECK
	else:
		return States.GameState.NORMAL

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
		# Update board array
		squares[piece.position[1]][piece.position[0]] = null
		piece.move(x, y)
	else:
		piece.position = [x, y]
	squares[y][x] = piece
	# Tell piece its new position
	
	# Update board model
	piece.translation = Vector3(origin.x + squareLength * x, origin.y, origin.z - squareLength * y)

func enPassant():
	if enPassant[1] == 5:
		squares[4][enPassant[0]].queue_free()
		squares[4][enPassant[0]] = null
	if enPassant[1] == 2:
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
	if moveValid:
		move(piece, x, y)
		whiteNext = !whiteNext
		emit_signal("turn", whiteNext)

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