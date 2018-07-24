extends Spatial

signal selected(piece)
export (NodePath) var shape
export (PackedScene) var flip

var position = null
var white = true
var alice = false
var selected = false
var board
const time = false

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

func update_material():
	print("HI")
	if white:
		if alice:
			if selected:
				set_material(load("res://Pieces/WhiteAliceHighlight.tres"))
			else:
				set_material(load("res://Pieces/WhiteAlice.tres"))
		else:
			if selected:
				set_material(load("res://Pieces/WhiteHighlight.tres"))
			else:
				set_material(load("res://Pieces/White.tres"))
	else:
		if alice:
			if selected:
				set_material(load("res://Pieces/BlackAliceHighlight.tres"))
			else:
				set_material(load("res://Pieces/BlackAlice.tres"))
		else:
			if selected:
				set_material(load("res://Pieces/BlackHighlight.tres"))
			else:
				set_material(load("res://Pieces/Black.tres"))

func is_white():
	return white

func set_white(isWhite):
	white = isWhite
	update_material()

func get_material():
	if shape != null:
		return get_node(shape).get_surface_material(0)

func get_moves(board):
	return null

func alice():
	alice = !alice
	update_material()

func select():
	selected = true
	update_material()

func deselect():
	selected = false
	update_material()

# Appends a move if it is possible, and returns true if no more moves can be made in this direction
func append_move(list, x, y):
	if !board.bounds(x) or !board.bounds(y): return true
	var piece = board.get_piece_at(x, y)
	if piece != null:
		if piece.time:
			return false
		if self.alice != piece.alice:
			return false
		if self.white == piece.white:
			return true
		list.append([x, y])
		return true
	list.append([x, y])
	return false

func time_flip(turns):
	var tile = flip.instance()
	tile.turnsLeft = turns
	tile.alice = alice
	tile.white = white
	tile.position = position
	tile.selected = false
	tile.board = board
	tile.piece = self
	board.add_child(tile)
	$Area/CollisionShape.disabled = true
	board.swap(self, tile)
	tile.update_material()
	return tile

func move(x, y):
	position[0] = x
	position[1] = y
	alice()
	board.enPassant = [-1, -1]