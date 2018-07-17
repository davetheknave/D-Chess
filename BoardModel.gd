extends Node

const squareLength = 0.450
const origin = Vector3(-0.19, 0, -0.07)
var white
var black
var board

func _init(whitePieces, blackPieces, board):
	white = whitePieces
	black = blackPieces
	self.board = board
	for piece in whitePieces.get_children():
		piece.set_material(load("res://Pieces/White.tres"))
		piece.white = true
		attach(piece)
	for piece in blackPieces.get_children():
		piece.set_material(load("res://Pieces/Black.tres"))
		piece.white = false
		attach(piece)

func attach(piece):
	piece.connect("selected", self, "select")

func hide_all_pieces():
	for c in white.get_children():
		c.hide()
	for c in black.get_children():
		c.hide()

func update_pieces(position):
	hide_all_pieces()
	var vert = 0
	var horz = 0
	for line in position:
		vert += 1
		horz = 0
		for character in line:
			if character == '1':
				horz += 1
			else:
				horz += 1
				adjust_one_piece(character, horz, vert)

func deselect_all():
	for i in white.get_children():
		deselect(i)
	for i in black.get_children():
		deselect(i)

func select(piece):
	deselect_all()
	if piece.white:
		piece.set_material(load("res://Pieces/WhiteHighlight.tres"))
	else:
		piece.set_material(load("res://Pieces/BlackHighlight.tres"))

func deselect(piece):
	if piece.white:
		piece.set_material(load("res://Pieces/White.tres"))
	else:
		piece.set_material(load("res://Pieces/Black.tres"))

func unhighlight_all():
	for i in board.get_node("White").get_children():
		unhighlight_square(i)
	for i in board.get_node("Black").get_children():
		unhighlight_square(i)

func highlight_square(pos):
	var colorWhite = get_square_color(pos)
	if colorWhite:
		pos.set_surface_material(0, load("res://Pieces/WhiteHighlight.tres"))
	else:
		pos.set_surface_material(0, load("res://Pieces/BlackHighlight.tres"))

func get_square_color(square):
	var letter = alphaToNum(square.name[0])
	var number = int(square.name[1])-1
	if ((letter + number) % 2) == 1:
		return true
	else:
		return false

func unhighlight_square(pos):
	var colorWhite = get_square_color(pos)
	if colorWhite:
		pos.set_surface_material(0, load("res://Pieces/White.tres"))
	else:
		pos.set_surface_material(0, load("res://Pieces/Black.tres"))

func get_square(x, y):
	var squares
	x = 7 - x
	y = 7 - y
	if ((x + y) % 2) == 1:
		squares = board.get_node("White")
	else:
		squares = board.get_node("Black")
	var squareName = numToAlpha(x)
	squareName = squareName + str(y+1)
	return squares.get_node(squareName)

func alphaToNum(l):
	match l:
		"A": return 0
		"B": return 1
		"C": return 2
		"D": return 3
		"E": return 4
		"F": return 5
		"G": return 6
		"H": return 7

func numToAlpha(n):
	match n:
		0: return "A"
		1: return "B"
		2: return "C"
		3: return "D"
		4: return "E"
		5: return "F"
		6: return "G"
		7: return "H"


func adjust_one_piece(id, horz, vert):
	var piece
	if typeof(id) == TYPE_STRING:
		piece = get_piece(id)
	else:
		piece = id
	piece.show()
	piece.position = [horz-1, 8-vert]
	piece.translation = Vector3(origin.x + squareLength * horz, origin.y, origin.z + squareLength * vert)

var pawnCount = [0,0]
var bishopCount = [0,0]
var knightCount = [0,0]
var rookCount = [0,0]
var kingCount = [0,0]
var queenCount = [0,0]
func get_piece(name):
	var side
	var sideID
	if name.to_lower() == name:
		side = black
		sideID = 0
	else:
		side = white
		sideID = 1
	name = name.to_lower()
	match name:
		"k": return side.get_node("King")
#			kingCount[sideID] += 1
#			if kingCount[sideID] > 8:
#				kingCount[sideID] = 1
#			return side.get_node("King" + str(kingCount[sideID]))
		"q": return side.get_node("King")
#			queenCount[sideID] += 1
#			if queenCount[sideID] > 8:
#				queenCount[sideID] = 1
#			return side.get_node("Queen" + str(queenCount[sideID]))
		"p":
			pawnCount[sideID] += 1
			if pawnCount[sideID] > 8:
				pawnCount[sideID] = 1
			return side.get_node("Pawn" + str(pawnCount[sideID]))
		"n":
			knightCount[sideID] += 1
			if knightCount[sideID] > 2:
				knightCount[sideID] = 1
			return side.get_node("Knight" + str(knightCount[sideID]))
		"b":
			bishopCount[sideID] += 1
			if bishopCount[sideID] > 2:
				bishopCount[sideID] = 1
			return side.get_node("Bishop" + str(bishopCount[sideID]))
		"r":
			rookCount[sideID] += 1
			if rookCount[sideID] > 2:
				rookCount[sideID] = 1
			return side.get_node("Rook" + str(rookCount[sideID]))