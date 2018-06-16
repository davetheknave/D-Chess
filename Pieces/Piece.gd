extends Spatial

signal selected(piece)
export (NodePath) var shape

var position = [0,0]
var white

func _ready():
	pass

func _on_input(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("selected", self)

func set_material(material):
	if shape != null:
		get_node(shape).set_surface_material(0, material)

func get_material():
	if shape != null:
		return get_node(shape).get_surface_material(0)