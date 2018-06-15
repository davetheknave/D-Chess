extends Spatial

signal release(name)

func _ready():
	for i in $White.get_children():
		attach(i)
	for i in $Black.get_children():
		attach(i)

func attach(square):
	square.create_convex_collision()
	var body = square.get_node(square.name+"_col")
	body.connect("input_event", self, "mouse_over", [square.name], CONNECT_DEFERRED)

func mouse_over(camera, event, click_position, click_normal, shape_idx, pos):
	if event is InputEventMouseButton:
		if !event.pressed:
			print(pos)
			emit_signal("release", pos)