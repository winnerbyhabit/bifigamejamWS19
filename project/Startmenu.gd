extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game.tscn")

func _on_Credits_pressed():
	#get_tree().change_scene("res://Credits.tscn")
	$Credits_screen.visible = true

func _on_Quit_pressed():
	get_tree().quit()