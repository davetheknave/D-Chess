extends "res://Pieces/Piece.gd"

var turnsLeft = 0
var piece
const time = true

func _ready():
	pass

func turn(white):
	turnsLeft -= 1
	print(turnsLeft)
	if turnsLeft <= 0:
		time_flip()
		piece.get_node("Area").get_node("CollisionShape").disabled = false

func time_flip(turns = 0):
	board.swap(self, piece)
	piece.show()
	hide()
	piece.alice = alice

func get_moves(board):
	return []