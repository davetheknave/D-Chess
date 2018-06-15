extends "res://Pieces/Piece.gd"

func set_material(material):
	$bKnightL_base.set_surface_material(0, material)
	$bKnightL_head.set_surface_material(0, material)

func get_material():
	return $bKnightL_base.get_surface_material(0)