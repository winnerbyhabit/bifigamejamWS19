extends Control


func _ready():
	pass # Replace with function body.

func _on_Exit_pressed():
	#get_tree().quit()
	get_tree().change_scene("res://Startmenu.tscn")

