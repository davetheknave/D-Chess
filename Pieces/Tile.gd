extends "res://Pieces/Piece.gd"

const time = true

var turnsLeft = 0
var active

func _ready():
	shape = get_node(shape)

func activate():
	.activate()
	active = true

func deactivate():
	.deactivate()
	active = false

func set_material():
	pass

var blackN = load("res://Colors/Black.tres")
var whiteN = load("res://Colors/White.tres")
var whiteA = load("res://Colors/WhiteAlice.tres")
var blackA = load("res://Colors/BlackAlice.tres")
var whiteH = load("res://Colors/WhiteHighlight.tres")
var blackH = load("res://Colors/BlackHighlight.tres")
var whiteAH = load("res://Colors/WhiteAliceHighlight.tres")
var blackAH = load("res://Colors/BlackAliceHighlight.tres")

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
		if turnsLeft <= 0:
			time_flip()
		$Tile.change_number(turnsLeft)

func get_moves(board):
	return []