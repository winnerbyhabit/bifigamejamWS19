extends Node2D

export var geld = 100
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

export var base_tower_energy_consumation = 5

export var sheeps = 1
export var goats = 0

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
		
		#energy
		update_energy(sheeps * energy_production_per_sheep_per_second)
		
		update_futter(sheeps * foot_consumation_per_sheep_per_second * -1)
		update_futter(goats * foot_consumation_per_goat_per_second * -1)
		update_futter(felder * base_foot_production)

# Called when the node enters the scene tree for the first time.
func _ready():
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
	sheeps += 1
	update_geld(-1*base_costs_sheep)
	$GUI.set_schafe(sheeps)

func add_goat():
	goats += 1
	$GUI.set_ziegen(goats)

func calculate_energy(anzahl):
	update_energy(-1 * anzahl * base_tower_energy_consumation)

func _on_TDGame_tower_placed():
	update_geld(-1 * base_costs_tower)


func _on_field_placed():
	felder += 1
	$GUI.set_food_per_sec(felder * base_foot_production)
	update_geld(-1*base_costs_field)
