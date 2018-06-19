extends Node

var model
var data

var pos

var piece

func _ready():
	model = preload("res://BoardModel.gd").new($WhitePieces, $BlackPieces, $Board)
	data = preload("res://BoardData.gd").new()
	pos = data.reset_game()
	for i in $WhitePieces.get_children():
		i.connect("selected", self, "_on_Piece_grab")
	for i in $BlackPieces.get_children():
		i.connect("selected", self, "_on_Piece_grab")
	data.connect("promotion", self, "promote")
	$HUD.connect("promoted", self, "finish_promotion")
	update()
	pass

func update():
	model.update_pieces(pos)

func move(startX, startY, endX, endY):
	endX -= 1
	endY -= 1
	var valid = data.is_valid_move(startX, startY, endX, endY)
	if not valid:
		return
	pos = data.move(startX, 7-startY, endX, 7-endY)
	update()
	$HUD.turn(data.whiteNext)

func _on_Board_release(pos, white):
	var n = get_numbers(pos.name)
	model.unhighlight_all()
	model.highlight_square(pos)
	if piece != null:
		model.deselect(piece)
		move(piece.position[0], piece.position[1], n[0], n[1])
	piece = null

func _on_Piece_grab(id):
	piece = id
	model.select(piece)
	model.unhighlight_all()
	if piece.white and not data.whiteNext:
		return
	if not piece.white and data.whiteNext:
		return
	var moves = data.get_piece_moves(data.get_piece_id(piece), piece.position[0], piece.position[1])
	for m in moves:
		model.highlight_square(model.get_square(m[0], m[1]))

var px
var py

func promote(x, y):
	get_tree().paused = true
	px = x
	py = y
	$HUD.promote()

func finish_promotion(piece):
	get_tree().paused = false
	if data.whiteNext:
		piece = piece.to_upper()
	data.position[7-py][px] = piece

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