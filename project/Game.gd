extends Node2D

export var geld = 100
export var energie = 100

export var base_costs_sheep = 50
export var base_costs_field = 50
export var base_costs_tower = 50

export var energy_production_per_sheep_per_second = 1

export var sheeps = 1

var threshold = 1

func _process(delta):
	threshold -= delta
	if threshold < 0:
		threshold += 1
		
		#energy
		update_energy(sheeps * energy_production_per_sheep_per_second)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_geld(0)
	update_energy(0)

#energiekosten Türme
func turmschuss(energie):
	energie -= 5
	get_node("GUI").set_energie(energie)

#futterfunktion
func futter(schaf, ziege, feld, futter):
	futter = futter - schaf * 5 - ziege * 5 + feld * 5
	get_node("GUI").set_futter(futter)

func update_energy(energy_add):
	energie += energy_add
	$GUI.set_energie(energie)

#gibt geld wenn ziege stirbt
func update_geld(geld_add):
	geld += geld_add
	get_node("GUI").set_geld(geld)

func _on_GUI_buy_sheep():
	update_geld(-1*base_costs_sheep)
	sheeps += 1
