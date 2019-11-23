extends Node2D

export var geld = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	update_geld(0)

#gibt Energie für Schafe
func energie(schaf, energie):
	energie = schaf * 5 + energie
	get_node("GUI").set_energie(energie)

#energiekosten Türme
func turmschuss(energie):
	energie -= 5
	get_node("GUI").set_energie(energie)

#futterfunktion
func futter(schaf, ziege, feld, futter):
	futter = futter - schaf * 5 - ziege * 5 + feld * 5
	get_node("GUI").set_futter(futter)

#gibt geld wenn ziege stirbt
func update_geld(geld_add):
	geld += geld_add
	get_node("GUI").set_geld(geld)