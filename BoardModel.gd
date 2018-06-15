extends Node

const squareLength = 0.450
const origin = Vector3(-0.19, 0, -0.07)
var white
var black

func _init(whitePieces, blackPieces):
	white = whitePieces
	black = blackPieces
	for piece in whitePieces.get_children():
		piece.set_material(load("res://Pieces/white.tres"))
		piece.white = true
		attach(piece)
	for piece in blackPieces.get_children():
		piece.set_material(load("res://Pieces/black.tres"))
		piece.white = false
		attach(piece)

func attach(piece):
	piece.connect("selected", self, "select", [piece])
	piece.connect("dropped", self, "deselect", [piece])

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

func select(piece):
	for i in white.get_children():
		deselect(i)
	for i in black.get_children():
		deselect(i)
	if piece.white:
		piece.set_material(load("res://Pieces/WhiteHighlight.tres"))
		piece.get_material().emission = Color(0.5,0.8,1)
		piece.get_material().emission_enabled = true
	else:
		piece.set_material(load("res://Pieces/BlackHighlight.tres"))
		piece.get_material().emission = Color(1,0.7,0.4)
		piece.get_material().emission_enabled = true

func deselect(piece):
	if piece.white:
		piece.set_material(load("res://Pieces/white.tres"))
	else:
		piece.set_material(load("res://Pieces/black.tres"))

func highlight_square(x, y):
	var square
	if (x + y) % 2 == 1:
		square.set_surface_material(0, load("res://Pieces/BlackHighlight.tres"))
	else:
		square.set_surface_material(0, load("res://Pieces/WhiteHighlight.tres"))

func adjust_one_piece(id, horz, vert):
	var piece
	if typeof(id) == TYPE_STRING:
		piece = get_piece(id)
	else:
		piece = id
	piece.show()
	piece.position = [horz, 9-vert]
	piece.translation = Vector3(origin.x + squareLength * horz, origin.y, origin.z + squareLength * vert)

var pawnCount = [0,0]
var bishopCount = [0,0]
var knightCount = [0,0]
var rookCount = [0,0]
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
		"q": return side.get_node("Queen")
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