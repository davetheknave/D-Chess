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

# Appends a move if it is possible, and returns true if no more moves can be made in this direction
func append_move(list, x, y):
	if !board.bounds(x): return true
	if !board.bounds(y): return true
	var piece = board.get_piece_at(x, y)
	if piece != null:
		if piece.white and white:
			return true
		elif !piece.white and !white:
			return true
	list.append([x, y])
	if piece!= null:
		return true
	return false

func move(x, y):
	position[0] = x
	position[1] = y