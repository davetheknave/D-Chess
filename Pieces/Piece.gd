extends Spatial

signal selected(piece)
export (NodePath) var shape
export (PackedScene) var flip

const time = false

var position = null
var white = true
var alice = false
var selected = false
var board
var other

func _ready():
	pass

func delete():
	if other != null:
		other.queue_free()
	queue_free()

func get_name():
	var string = ""
	if white:
		string += "White"
	else:
		string += "Black"
	if alice:
		string += " Alice "
	return string + name

func init(board, white):
	other = flip.instance()
	self.board = board
	other.board = board
	other.white = white
	self.white = white
	other.other = self
	board.add_child(other)
	other.deactivate()

func activate():
	show()
	$Area/CollisionShape.disabled = false

func deactivate():
	hide()
	$Area/CollisionShape.disabled = true

func set_material(material):
	if shape != null:
		get_node(shape).set_surface_material(0, material)

func update_material():
	if white:
		if alice:
			if selected:
				set_material(load("res://Colors/WhiteAliceHighlight.tres"))
			else:
				set_material(load("res://Colors/WhiteAlice.tres"))
		else:
			if selected:
				set_material(load("res://Colors/WhiteHighlight.tres"))
			else:
				set_material(load("res://Colors/White.tres"))
	else:
		if alice:
			if selected:
				set_material(load("res://Colors/BlackAliceHighlight.tres"))
			else:
				set_material(load("res://Colors/BlackAlice.tres"))
		else:
			if selected:
				set_material(load("res://Colors/BlackHighlight.tres"))
			else:
				set_material(load("res://Colors/Black.tres"))

func get_moves(board):
	return null

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
		if piece.time and board.turnsMove != piece.turnsLeft:
			return false
		if self.alice != piece.alice:
			return false
		if self.white == piece.white:
			return true
		list.append([x, y])
		return true
	list.append([x, y])
	return false

func time_flip(turns = 0):
	other.activate()
	other.turnsLeft = turns
	other.alice = alice
	other.position = position
	board.swap(self, other)
	deactivate()
	return other
	
func turn():
	pass

func move(x, y):
	position[0] = x
	position[1] = y
	alice = !alice
	update_material()
	board.enPassant = [-1, -1]