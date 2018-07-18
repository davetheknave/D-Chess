extends Spatial

export (PackedScene) var king
export (PackedScene) var queen
export (PackedScene) var bishop
export (PackedScene) var pawn
export (PackedScene) var rook
export (PackedScene) var knight

signal promote(piece)

const squareLength = 0.495
const origin = Vector3(-0.99, 0.5, -0.4)
const START_POSITION = ["rnbqkbn1","pppppppP","11111111","11111111","11111111","11111111","PPPPPPPp","RNBQKBN1"]

var squares = []
var currentPiece
var whiteNext = true
var enPassant = [-1,-1]

signal release(name)

func _ready():
	for i in $White.get_children():
		attach(i, true)
	for i in $Black.get_children():
		attach(i, false)
	pass
	for x in 8:
		squares.append([null,null,null,null,null,null,null,null])
		for y in 8:
			squares[x][y] = null
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
			piece.board = self
			piece.connect("selected", self, "piece_clicked")
			move(piece, j, i)
			if "moved" in piece:
				piece.moved = false

func piece_clicked(piece):
	currentPiece = piece
	deselect_all()

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

func attach(square, white):
	square.create_convex_collision()
	var body = square.get_node(square.name+"_col")
	body.connect("input_event", self, "mouse_over", [square, white], CONNECT_DEFERRED)

func get_piece_at(x, y):
	if !bounds(x) or !bounds(y):
		return null
	return squares[y][x]

func move(piece, x, y):
	# Capture any pieces
	if squares[y][x] != null:
		squares[y][x].queue_free()
	# Update board array
	squares[piece.position[1]][piece.position[0]] = null
	squares[y][x] = piece
	# Tell piece its new position
	piece.move(x, y)
	# Update board model
	piece.translation = Vector3(origin.x + squareLength * x, origin.y, origin.z - squareLength * y)

func mouse_over(camera, event, click_position, click_normal, shape_idx, pos, white):
	if event is InputEventMouseButton:
		if !event.pressed:
			emit_signal("release", pos, white)
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