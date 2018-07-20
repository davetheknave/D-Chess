extends Node

var board

var pos

var piece

var state

func _ready():
	$HUD.connect("promoted", self, "finish_promotion")
	board = $Board
	board.connect("promote", self, "promote")
	board.connect("turn", self, "change_turn")

func change_turn(white):
	$HUD.turn(white)
	state = board.get_state()
	$HUD.set_state(state)

func promote(piece):
	get_tree().paused = true
	$HUD.promote()

func finish_promotion(piece):
	get_tree().paused = false
	board.finish_promotion(piece)
