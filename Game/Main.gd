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

func _on_HUD_time(turns):
	board.time_travel(turns)

func select(piece):
	selected = piece
	$Timer.start()

const rayLength = 5000

func _input(event):
	if event is InputEventMouseButton:
		if not event.pressed:
			if $Timer.time_left == 0:
				var result = pick(event, false)
				if not result.empty():
					board.try_move(board.currentPiece, result.collider)
				if selected != null:
					release(selected)
		else:
			release(selected)
	if event is InputEventMouseMotion and selected != null:
		var result = pick(event, false)
		if not result.empty():
			var basis = Basis(Vector3(.92,0,0),Vector3(0,.92,0),Vector3(0,0,.92))
			var difference = Transform(basis, Vector3(result.position[0], 0.1, result.position[2]))
			selected.set_global_transform(difference)

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