extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal add_sheep;
signal add_tower;
signal add_laser_tower;
signal add_field;



func _on_SheepButton_pressed():
	toggle_menu()
	emit_signal("add_sheep")


func _on_TowerButton_pressed():
	toggle_menu()
	emit_signal("add_tower")

func _on_FieldButton_pressed():
	toggle_menu()
	emit_signal("add_field")


func _on_ShopButton_pressed():
	toggle_menu()

func toggle_menu():
	$VBoxContainer.visible = not $VBoxContainer.visible
	$Background.visible = not $Background.visible

func _on_LaserTowerButton_pressed():
	toggle_menu()
	emit_signal("add_laser_tower")
