extends Spatial

const coverNumbers = ["000010000", "100000001", "100010001", "101000101", "101010101", "111000111", "111010111", "111101111", "111111111"]

func _ready():
	pass

func change_number(n):
	var pattern = coverNumbers[n-1]
	for i in 9:
		var cover = get_node("Covers_00" + str(i+1))
		if pattern[i] == '1':
			cover.hide()
		else:
			cover.show()

func color(tile, pips):
	color_tile(tile)
	color_pips(pips)

func color_tile(material):
	for i in get_children():
		if i.name != "Pips" and i.has_method("set_surface_material"):
			i.set_surface_material(0, material)
	$Pips.set_surface_material(0, material)

func color_pips(material):
	$Pips.set_surface_material(1, material)