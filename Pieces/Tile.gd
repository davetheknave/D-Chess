extends "res://Pieces/Piece.gd"

var turnsLeft = 0
var piece
var active
const time = true

func _ready():
	pass

func make_flip():
	pass

func activate():
	.activate()
	active = true

func deactivate():
	.deactivate()
	active = false

func turn(white):
	if active:
		turnsLeft -= 1
	print(turnsLeft)
	if turnsLeft <= 0:
		time_flip()
		piece.activate()

func time_flip(turns = 0):
	piece.show()
	deactivate()
	piece.alice = alice

func get_moves(board):
	return []