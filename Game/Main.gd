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
	match state:
		States.GameState.WHITECHECKMATE, \
		States.GameState.BLACKCHECKMATE, \
		States.GameState.STALEMATE:
			get_tree().paused = true

func promote(piece):
	get_tree().paused = true
	$HUD.promote()

func finish_promotion(piece):
	get_tree().paused = false
	board.finish_promotion(piece)

func _on_HUD_reset():
	board.reset()
	$HUD._ready()
	get_tree().paused = false

func _on_HUD_time(turns):
	board.time_travel(turns)
