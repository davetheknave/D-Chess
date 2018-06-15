extends Node

var model
var data

var pos

var piece

func _ready():
	model = preload("res://BoardModel.gd").new($WhitePieces, $BlackPieces)
	data = preload("res://BoardData.gd").new()
	pos = data.reset_game()
	for i in $WhitePieces.get_children():
		i.connect("selected", self, "_on_Piece_grab")
	for i in $BlackPieces.get_children():
		i.connect("selected", self, "_on_Piece_grab")
	update()
	pass

func update():
	model.update_pieces(pos)

func move(startX, startY, endX, endY):
	startY = 8 - startY
	endY = 8 - endY
	startX = startX - 1
	endX = endX - 1
	var valid = data.is_valid_move(startX, startY, endX, endY)
	if not valid:
		return
	pos = data.move(startX, startY, endX, endY)
	update()
	$HUD.turn(data.whiteNext)

#func _input(event):
##	if event is InputEventMouseButton:
##		if not event.pressed:
##			piece = null
#	pass

func _on_Board_release(pos):
	var n = get_numbers(pos)
	print(piece)
	if piece != null:
		model.deselect(piece)
		move(piece.position[0], piece.position[1], n[0], n[1])
	piece = null

func _on_Piece_grab(id):
	piece = id
	model.select(piece)
#	$OmniLight.show()
#	$OmniLight.translation = Vector3(.45*id.position[0], .1, .45*id.position[1])

func get_numbers(pos):
	var numbers = []
	match pos[0]:
		"A": numbers.append(1)
		"B": numbers.append(2)
		"C": numbers.append(3)
		"D": numbers.append(4)
		"E": numbers.append(5)
		"F": numbers.append(6)
		"G": numbers.append(7)
		"H": numbers.append(8)
	numbers.append(int(pos[1]))
	numbers[0] = 9 - numbers[0]
	numbers[1] = 9 - numbers[1]
	return numbers