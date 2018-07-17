extends Spatial

signal selected(piece)
export (NodePath) var shape

var position = [0,0]
var white = true
var alice = false
var board

func get_name():
	return str(white)

func _ready():
	pass

func _on_input(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("selected", self)
			select()

func set_material(material):
	if shape != null:
		get_node(shape).set_surface_material(0, material)

func is_white():
	return white

func set_white(isWhite):
	white = isWhite
	if isWhite:
		set_material(load("res://Pieces/White.tres"))
	else:
		set_material(load("res://Pieces/Black.tres"))

func get_material():
	if shape != null:
		return get_node(shape).get_surface_material(0)

func get_moves(board):
	return null

func alice(isAlice):
	pass

func select():
	if white:
		set_material(load("res://Pieces/WhiteHighlight.tres"))
	else:
		set_material(load("res://Pieces/BlackHighlight.tres"))

func deselect():
	if white:
		set_material(load("res://Pieces/White.tres"))
	else:
		set_material(load("res://Pieces/Black.tres"))


func append_move(list, x, y):
	if !bounds(x): return true
	if !bounds(y): return true
	var piece = board.get_piece_at(x, y)
	if piece != null:
		if piece.white and white:
			return true
		elif !piece.white and !white:
			return true
	list.append([x, y])
	return false

func bounds(n):
	if n < 0 or n > 7:
		return false
	else:
		return true