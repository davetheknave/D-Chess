extends Node

var board

var model
var data

var pos

var piece

func _ready():
	$HUD.connect("promoted", self, "finish_promotion")
	board = $Board
	board.connect("promote", self, "promote")
	board.connect("turn", self, "change_turn")

func change_turn(white):
	$HUD.turn(white)

func promote(piece):
	get_tree().paused = true
	$HUD.promote()

func finish_promotion(piece):
	get_tree().paused = false
	board.finish_promotion(piece)