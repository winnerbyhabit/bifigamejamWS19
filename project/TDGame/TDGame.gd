extends Node2D

var goat_scene = load("res://TDGame/Goat.tscn")
var tower_scene = load("res://TDGame/Tower.tscn")

var tower_cursor = load("res://assets/Tower_1.png")

export(String, FILE) var wavesTXT

var waves = []

var threshold = 0

var towerplacement_active = false

export var gridsize = 64

export var anzahl_kacheln = Vector2(8,9)

export var goat_kill_coins = 10

signal recieve_coins(coins_count)
signal goat_win
signal tower_placed

func _input(event):
	if towerplacement_active:
		if Input.is_action_pressed("left_click"):
			var click_position = event.position
			click_position.x = floor(click_position.x / gridsize)
			click_position.y = floor(click_position.y / gridsize)
			if click_position.x >= 0 and click_position.x < anzahl_kacheln.x and click_position.y >= 0 and click_position.y < anzahl_kacheln.y: 
				place_tower(click_position)
			


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if file.file_exists(wavesTXT):
		file.open(wavesTXT, file.READ)
		while !file.eof_reached():
			var csv = file.get_csv_line (" ")
			waves.push_back(csv)
		file.close()
	print(waves)
	set_process(true)

func _process(delta):
	threshold -= delta
	if threshold < 0:
		var befehl = waves.pop_front()
		if waves.size() > 0:
			if befehl[0] == "spawn":
				spawn_goat()
			elif befehl[0] == "pause":
				threshold += float(befehl[1])
		else:
			print('keine weiteren Schafe')
			set_process(false)

func on_goat_win():
	print("ziegen punkt")
	emit_signal("goat_win")

func spawn_goat():
	var goat = goat_scene.instance()
	add_child(goat)
	goat.connect("win",self,"on_goat_win")
	goat.connect("loose",self,"on_goat_kill")

func activate_tower_placement():
	towerplacement_active = true
	Input.set_custom_mouse_cursor(tower_cursor,0,Vector2(gridsize/2,gridsize/2))


func place_tower(position):
	if tower_placement_possible(position):
		towerplacement_active = false
		Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
		var tower = tower_scene.instance()
		tower.position = position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2)
		tower.show_tower_range(false)
		add_child(tower)
		emit_signal("tower_placed")

func tower_placement_possible(position):
	#prüfe ob weg
	if $Navigation2D/TileMap.get_cell(position.x,position.y) != 15:
		return false
	
	#prüffe ob anderer Turm
	var children = self.get_children()
	for c in children:
		if c.is_in_group("tower"):
			if c.position == position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2):
				return false
	
	return true

func next_wave():
	threshold = 0

func on_goat_kill():
	emit_signal("recieve_coins",goat_kill_coins)