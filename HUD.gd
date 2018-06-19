extends Control

signal promoted

func _ready():
	pass

func turn(white):
	if white:
		$VBoxContainer/Turn.text = "White's turn"
	else:
		$VBoxContainer/Turn.text = "Black's turn"

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
