extends "res://Pieces/Piece.gd"

var turnsLeft = 0
var piece
var active
const time = true

func _ready():
	shape = get_node(shape)

func make_flip():
	pass

func activate():
	.activate()
	active = true
#	shape.change_number(turnsLeft)

func deactivate():
	.deactivate()
	active = false

func get_material():
	pass

func set_material():
	pass

var blackN = load("res://Pieces/Black.tres")
var whiteN = load("res://Pieces/White.tres")
var whiteA = load("res://Pieces/WhiteAlice.tres")
var blackA = load("res://Pieces/BlackAlice.tres")
var whiteH = load("res://Pieces/WhiteHighlight.tres")
var blackH = load("res://Pieces/BlackHighlight.tres")
var whiteAH = load("res://Pieces/WhiteAliceHighlight.tres")
var blackAH = load("res://Pieces/BlackAliceHighlight.tres")

func update_material():
	if white:
		if alice:
			if selected:
				shape.color(whiteAH, blackAH)
			else:
				shape.color(whiteA, blackA)
		else:
			if selected:
				shape.color(whiteH, blackH)
			else:
				shape.color(whiteN, blackN)
	else:
		if alice:
			if selected:
				shape.color(blackAH, whiteAH)
			else:
				shape.color(blackA, whiteA)
		else:
			if selected:
				shape.color(blackH, whiteH)
			else:
				shape.color(blackN, whiteN)

func turn(white):
	if active:
		turnsLeft -= 1
	print(turnsLeft)
	if turnsLeft <= 0:
		time_flip()
		piece.activate()
	$Tile.change_number(turnsLeft)

func time_flip(turns = 0):
	piece.show()
	deactivate()
	piece.alice = alice

func get_moves(board):
	return []