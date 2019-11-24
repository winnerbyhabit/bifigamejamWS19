extends Node2D


#tileset id
var sheep_exists = 2
var goat_exists = 3

var fieldplacement_active = false

export var anzahl_kacheln = Vector2(8,9)

export var gridsize = 64

signal field_placed

var field_cursor = load("res://assets/T22.png")

var field_id = 1
var buyable_field_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func add_sheep(sheep):
	sheep += 1

func add_goat(goat):
	goat += 1

#func add_field(field):
#	field += 1

func _input(event):
	if fieldplacement_active:
		if Input.is_action_pressed("left_click"):
			var click_position = event.position - self.position
			click_position.x = floor(click_position.x / gridsize)
			click_position.y = floor(click_position.y / gridsize)
			if click_position.x >= 0 and click_position.x < anzahl_kacheln.x and click_position.y >= 5 and click_position.y < anzahl_kacheln.y: 
				place_field(click_position)
		if Input.is_action_pressed("cancel"):
			fieldplacement_active = false
			Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)

func activate_field_placement():
	fieldplacement_active = true
	Input.set_custom_mouse_cursor(field_cursor,0,Vector2(gridsize/2,gridsize/2))

func place_field(position):
	print('place field: ' ,position)
	if field_placement_possible(position):
		fieldplacement_active = false
		Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
		$TileMap.set_cellv(position, field_id)
		emit_signal("field_placed")

func field_placement_possible(position):
	if $TileMap.get_cellv(position) == buyable_field_id:
		return true
	return false
	

func place_sheep_in_stall():
	var ortx = rand_range(0, 7)
	var orty = rand_range(0, 3)
	var ort = Vector2(ortx, orty)
	if $TileMap.get_cellv(ort) != sheep_exists and $TileMap.get_cellv(ort) != goat_exists :
		$TileMap.set_cellv(ort, sheep_exists)


func _on_TDGame_goat_win():
	var ortx = rand_range(0, 7)
	var orty = rand_range(0, 3)
	var ort = Vector2(ortx, orty)
	if $TileMap.get_cellv(ort) != sheep_exists and $TileMap.get_cellv(ort) != goat_exists :
		$TileMap.set_cellv(ort, goat_exists)
