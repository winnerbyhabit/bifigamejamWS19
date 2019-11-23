extends Control

signal add_tower

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_geld(value):
	$HBoxContainer/Geld/Value.text = value

func set_futter(value):
	$HBoxContainer/Futter/Value.text = value

func set_energie(value):
	$HBoxContainer/Energie/Value.text = value

func _on_Shopping_add_tower():
	emit_signal("add_tower")
