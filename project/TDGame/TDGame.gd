extends Node2D

var goat_scene = load("res://TDGame/Goat.tscn")
var tower_scene = load("res://TDGame/Tower.tscn")

var tower_cursor = load("res://assets/Turm1x.png")
var laser_tower_cursor = load("res://assets/LaserTurm.png")

export(String, FILE) var wavesTXT

export(PackedScene) var level

var waves = []

var threshold = 0

var towerplacement_active = false
var lasertowerplacement_active = false

export var gridsize = 64

export var anzahl_kacheln = Vector2(8,9)

export var goat_kill_coins = 10

signal recieve_coins(coins_count)

signal goat_win
signal tower_placed
signal tower_fired
signal winner_by_habit

func _input(event):
	if towerplacement_active or lasertowerplacement_active:
		if Input.is_action_pressed("left_click"):
			var click_position = event.position
			click_position.x = floor(click_position.x / gridsize)
			click_position.y = floor(click_position.y / gridsize)
			if click_position.x >= 0 and click_position.x < anzahl_kacheln.x and click_position.y >= 0 and click_position.y < anzahl_kacheln.y: 
				if towerplacement_active:
					place_tower(click_position)
				elif lasertowerplacement_active:
					place_lasertower(click_position)
		if Input.is_action_pressed("cancel"):
			towerplacement_active = false
			lasertowerplacement_active = false
			Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Navigation2D.add_child(level.instance())
	
	var file = File.new()
	if file.file_exists(wavesTXT):
		file.open(wavesTXT, file.READ)
		while !file.eof_reached():
			var csv = file.get_csv_line (" ")
			waves.push_back(csv)
		file.close()
	#print(waves)
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
			elif befehl[0] == "win":
				emit_signal("winner_by_habit")
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
		tower.connect("tower_fired",self,"on_tower_fire")
		tower.connect("tower_upgraded",self,"on_tower_upgrade")
		add_child(tower)
		emit_signal("tower_placed")

func place_lasertower(position):
	if tower_placement_possible(position):
		lasertowerplacement_active = false
		Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
		var tower = tower_scene.instance()
		tower.position = position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2)
		tower.show_tower_range(false)
		tower.connect("tower_fired",self,"on_tower_fire")
		tower.connect("tower_upgraded",self,"on_tower_upgrade")
		tower.set_lasertower()
		add_child(tower)
		emit_signal("tower_placed")

func tower_placement_possible(position):
	if not get_parent().is_there_money_for_tower():
		return false
	#prüfe ob weg
	match $Navigation2D/TileMap.get_cell(position.x,position.y):
		0: 
			return false
		1:
			return false
		2:
			return false
		3:
			return false
		7:
			return false
		8:
			return false
		_:
			#prüffe ob anderer Turm
			var children = self.get_children()
			for c in children:
				if c.is_in_group("tower"):
					if c.position == position * Vector2(gridsize,gridsize) + Vector2(gridsize/2,gridsize/2):
						return false
	
	return true

func on_tower_upgrade():
	emit_signal("tower_placed")

func next_wave():
	threshold = 0

func on_goat_kill():
	emit_signal("recieve_coins",goat_kill_coins)
	
func on_tower_fire(anzahl):
	emit_signal("tower_fired",anzahl)
	
func enable_shooting(value):
	var children = get_children()
	for child in children:
		if child.is_in_group("tower"):
			child.enable_shooting(value)

func activate_laser_tower_placement():
	lasertowerplacement_active = true
	Input.set_custom_mouse_cursor(laser_tower_cursor,0,Vector2(gridsize/2,gridsize/2))


func load_level(node):
	$Navigation2D.add_child(node)
	$Navigation2D.navpoly_remove(0)
