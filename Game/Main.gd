extends Spatial

onready var board = $Board
var pos
var promoted
var state
var selected

func _ready():
	pass

func change_turn(white):
	$HUD.turn(white)
	state = board.get_state()
	$HUD.set_state(state)
	match state:
		States.GameState.WHITECHECKMATE, \
		States.GameState.BLACKCHECKMATE, \
		States.GameState.STALEMATE:
			get_tree().paused = true

func promote(promoted):
	get_tree().paused = true
	$HUD.promote()

func finish_promotion(promoted):
	get_tree().paused = false
	board.finish_promotion(promoted)

func _on_HUD_reset():
	board.reset()
	$HUD._ready()
	get_tree().paused = false

func select(piece):
	if piece.white == board.whiteNext:
		selected = piece
		piece.select()

const rayLength = 5000

func _input(event):
	if selected != null:
		if event is InputEventMouseButton:
			if not event.pressed and $Timer.time_left == 0:
				var result = pick(event, false)
				if not result.empty():
					var piece = board.get_piece_on(result.collider)
					if piece != null and piece == selected:
						release(selected)
					elif piece != null and piece.white == board.whiteNext:
						release(selected)
						select(piece)
					else:
						board.try_move(selected, result.collider, $HUD.time)
						release(selected)
		elif event is InputEventMouseMotion:
			var result = pick(event, false)
			if not result.empty():
				var basis = Basis(Vector3(.92,0,0),Vector3(0,.92,0),Vector3(0,0,.92))
				var mousePos = Transform(basis, Vector3(result.position[0], 0.1, result.position[2]))
				selected.set_global_transform(mousePos)
	else:
		if event is InputEventMouseButton:
			if event.pressed:
				var result = pick(event, true)
				if not result.empty():
					$Timer.start()
					select(result.collider.get_parent())

func pick(event, pieces):
	var camera = $Camera
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * rayLength
	var space_state = get_world().direct_space_state
	var bitmask
	if pieces:
		bitmask = 1
	else:
		bitmask = 2
	return space_state.intersect_ray(from, to, [], bitmask)

func release(name):
	if name != null:
		board.place(name, name.position[0], name.position[1])
		selected = null
	board.deselect_all()