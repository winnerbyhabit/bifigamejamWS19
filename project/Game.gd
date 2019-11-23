extends Node2D

export var geld = 100
export var energie = 100
export var futter = 100


export var base_costs_sheep = 50
export var base_costs_field = 50
export var base_costs_tower = 50

export var energy_production_per_sheep_per_second = 1
export var foot_consumation_per_sheep_per_second = 1

export var sheeps = 1

var threshold = 1

func _process(delta):
	threshold -= delta
	if threshold < 0:
		threshold += 1
		
		#energy
		update_energy(sheeps * energy_production_per_sheep_per_second)
		
		update_futter(sheeps * foot_consumation_per_sheep_per_second * -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_geld(0)
	update_energy(0)
	$GUI.set_schafe(sheeps)

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




func _on_TDGame_tower_placed():
	update_geld(-1 * base_costs_tower)
