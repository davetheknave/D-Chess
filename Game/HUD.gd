extends Control

signal promoted
signal reset
onready var stateLabel = $HBoxContainer/VBoxContainer/Check
onready var turnText = $HBoxContainer/VBoxContainer/Turn
var time = 1

func _ready():
	stateLabel.text = "Start"
	turnText.text = "White's turn"

func turn(white):
	if white:
		turnText.text = "White's turn"
	else:
		turnText.text = "Black's turn"
	reset_time()

func set_state(state):
	match state:
		States.GameState.NORMAL: stateLabel.text = "Playing"
		States.GameState.BLACKCHECK: stateLabel.text = "Black is in check"
		States.GameState.WHITECHECK: stateLabel.text = "White is in check"
		States.GameState.BLACKCHECKMATE: stateLabel.text = "White has won!"
		States.GameState.WHITECHECKMATE: stateLabel.text = "Black has won!"
		States.GameState.STALEMATE: stateLabel.text = "Stalemate"

func reset_time():
	$HBoxContainer/TimeControls/Move1.pressed = true
	time = 1

var piece

func promote(piece):
	self.piece = piece
	$PromotionPopup.show()

func _on_Queen_pressed():
	emit_signal("promoted", piece, "q")
	piece = null
	$PromotionPopup.hide()

func _on_Rook_pressed():
	emit_signal("promoted", piece, "r")
	piece = null
	$PromotionPopup.hide()

func _on_Bishop_pressed():
	emit_signal("promoted", piece, "b")
	piece = null
	$PromotionPopup.hide()

func _on_Knight_pressed():
	emit_signal("promoted", piece, "n")
	piece = null
	$PromotionPopup.hide()

func _on_Button_pressed():
	emit_signal("reset")

func _on_TimeControls_change(turns):
	time = turns
