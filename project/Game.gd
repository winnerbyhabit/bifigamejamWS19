extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
func geld(geld):
	geld += 3
	get_node("GUI").set_geld(geld)