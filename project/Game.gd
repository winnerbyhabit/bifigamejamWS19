extends Node2D

export var geld = 250
export var energie = 100
export var futter = 100
export var felder = 1

export var base_costs_sheep = 50
export var base_costs_field = 50
export var base_costs_tower = 50

export var energy_production_per_sheep_per_second = 1
export var foot_consumation_per_sheep_per_second = 1

export var foot_consumation_per_goat_per_second = 1

export var base_foot_production = 1

export var base_tower_energy_consumation = 3
export var multihit_energy_conumation_factor = 1.5

export var sheeps = 1
export var goats = 0

export(String) var level_path = "res://TDGame/Levels/Level$number.tscn"

var shooting_allowed = true

var threshold = 1

func _process(delta):
	threshold -= delta
	if energie < 0:
		if shooting_allowed:
			$TDGame.enable_shooting(false)
			shooting_allowed = false
	else:
		if not shooting_allowed :
			$TDGame.enable_shooting(true)
			shooting_allowed = true
		
	if threshold < 0:
		threshold += 1
		
		#futter ernten
		update_futter(felder * base_foot_production)
		
		#energy
		var food_consumation = sheeps * foot_consumation_per_sheep_per_second * -1 + (-1 * goats * foot_consumation_per_goat_per_second)
		if food_consumation < futter:
			update_futter(food_consumation)
			update_energy(sheeps * energy_production_per_sheep_per_second)
		

	if check_if_lost():
		$LostScreen.visible = true
		get_tree().paused = true
		$LostScreen/Death_audiostream.play(0)
		$AudioStreamPlayer.playing = false
		
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	update_geld(0)
	update_energy(0)
	$GUI.set_schafe(sheeps)
	$GUI.set_ziegen(goats)

func update_energy(energy_add):
	energie += energy_add
	$GUI.set_energie(energie)

#gibt geld wenn ziege stirbt
func update_geld(geld_add):
	geld += geld_add
	get_node("GUI").set_geld(geld)

func update_futter(futter_add):
	futter += futter_add
	$GUI.set_futter(futter)

func _on_GUI_buy_sheep():
	if geld >=base_costs_sheep:
		$GUI.show_notification("BEEP BEEP, I'M A SHEEP")
		sheeps += 1
		update_geld(-1*base_costs_sheep)
		$GUI.set_schafe(sheeps)
		$Stall.place_sheep_in_stall()
		$beep_beep.play(0)

func add_goat():
	$GUI.show_notification("MOOW MOOW I'M A COW")
	goats += 1
	$GUI.set_ziegen(goats)

func calculate_energy(anzahl):
	var e = floor(-1 * base_tower_energy_consumation + -1 * (anzahl-1) * base_tower_energy_consumation * multihit_energy_conumation_factor)
	update_energy(e)

func _on_TDGame_tower_placed():
	update_geld(-1 * base_costs_tower)

func is_there_money_for_tower():
	if geld >= base_costs_tower:
		return true
	return false

func is_there_money_for_field():
	if geld >= base_costs_field:
		return true
	return false

func _on_field_placed():
	$GUI.show_notification("Gelder für Felder")
	felder += 1
	$GUI.set_food_per_sec(felder * base_foot_production)
	update_geld(-1*base_costs_field)

func check_if_lost():
	if goats > 5 and goats > sheeps:
		return true
	return false


func _on_TDGame_winner_by_habit():
	#$Credits_screen.visible = true
	#get_tree().change_scene("res://Credits.tscn")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Winscreen.tscn")
	#pass


func load_level(number):
	var path = level_path.replace("$number",str(number))
	var node_instance = load(path).instance()
	$TDGame.load_level(node_instance)
	$LevelChooser.visible = false
	get_tree().paused = false
