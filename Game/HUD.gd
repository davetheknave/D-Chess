extends Control

signal promoted
signal reset
signal time(turns)
onready var stateLabel = $HBoxContainer/VBoxContainer/Check
onready var turnText = $HBoxContainer/VBoxContainer/Turn

func _ready():
	stateLabel.text = "Start"
	turnText.text = "White's turn"

func turn(white):
	if white:
		turnText.text = "White's turn"
	else:
		turnText.text = "Black's turn"

func set_state(state):
	match state:
		States.GameState.NORMAL: stateLabel.text = "Playing"
		States.GameState.BLACKCHECK: stateLabel.text = "Black is in check"
		States.GameState.WHITECHECK: stateLabel.text = "White is in check"
		States.GameState.BLACKCHECKMATE: stateLabel.text = "White has won!"
		States.GameState.WHITECHECKMATE: stateLabel.text = "Black has won!"
		States.GameState.STALEMATE: stateLabel.text = "Stalemate"

func promote():
	$PromotionPopup.show()

func _on_Queen_pressed():
	emit_signal("promoted", "q")
	$PromotionPopup.hide()

func _on_Rook_pressed():
	emit_signal("promoted", "r")
	$PromotionPopup.hide()

func _on_Bishop_pressed():
	emit_signal("promoted", "b")
	$PromotionPopup.hide()

func _on_Knight_pressed():
	emit_signal("promoted", "n")
	$PromotionPopup.hide()

func _on_Button_pressed():
	emit_signal("reset")


func _on_TimeControls_change(turns):
	emit_signal("time", turns)
