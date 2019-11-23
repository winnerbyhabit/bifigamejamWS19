extends Node2D

var sheep = 1

var goat = 0

var field = 1

var fieldplacement_active = false

export var anzahl_kacheln = Vector2(8,9)

export var gridsize = 64

var field_cursor = load("res://assets/Tower_1.png")

# Called when the node enters the scene tree for the first time.
func _ready():
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
			var click_position = event.position
			click_position.x = floor(click_position.x / gridsize)
			click_position.y = floor(click_position.y / gridsize)
			if click_position.x >= 0 and click_position.x < anzahl_kacheln.x and click_position.y >= 5 and click_position.y < anzahl_kacheln.y: 
				place_field(click_position)				

func activate_field_placement():
	fieldplacement_active = true
	print("määäääääääääh")
	Input.set_custom_mouse_cursor(field_cursor,0,Vector2(gridsize/2,gridsize/2))

func place_field(position):
	if field_placement_possible(position):
		fieldplacement_active = false
		Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
		#var tower = tower_scene.instance()
		field.position = position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2)
		#tower.show_tower_range(false)
		#add_child(tower)
		field += 1
		get_node("TileMap").set_cell(position, 2)

func field_placement_possible(position):
	#prüfe ob feld/ muss noch angepasst werden and neues tileset
	if $Stall/TileMap.get_cell(position.x,position.y) != 2:
		return true
	#prüfung für feldteil des rechten felds oder true/fale umdrehen und auf brache prüfen
	
	#prüffe ob anderer Turm
	#var children = self.get_children()
	#for c in children:
	#	if c.is_in_group("tower"):
	#		print(c.position,position* Vector2(gridsize,gridsize))
	#		if c.position == position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2):
	#			return false
	
	return false

