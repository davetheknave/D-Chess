extends Control

signal promoted
signal reset
onready var stateLabel = $VBoxContainer/Check

func _ready():
	stateLabel.text = "Start"
	$VBoxContainer/Turn.text = "White's turn"

func turn(white):
	if white:
		$VBoxContainer/Turn.text = "White's turn"
	else:
		$VBoxContainer/Turn.text = "Black's turn"

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
