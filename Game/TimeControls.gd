extends VBoxContainer

signal change(turns)

var state = 1

func change(newState):
	state = newState
	emit_signal("change", state)