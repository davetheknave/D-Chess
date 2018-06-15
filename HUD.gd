extends Control

func _ready():
	pass

func turn(white):
	if white:
		$VBoxContainer/Turn.text = "White's turn"
	else:
		$VBoxContainer/Turn.text = "Black's turn"