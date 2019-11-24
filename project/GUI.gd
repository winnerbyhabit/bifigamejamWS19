extends Control

signal add_tower
signal add_laser_tower
signal next_wave
signal buy_sheep
signal buy_field


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_geld(value):
	$HBoxContainer/Geld/Value.text = str(value)

func set_futter(value):
	$HBoxContainer/Futter/Value.text = str(value)

func set_energie(value):
	$HBoxContainer/Energie/Value.text = str(value)

func set_schafe(value):
	$HBoxContainer2/Schafe/Value.text = str(value)

func set_ziegen(value):
	$HBoxContainer2/Ziegen/Value.text = str(value)

func set_food_per_sec(value):
	$HBoxContainer2/FoodPerSec/Value.text = str(value)

func _on_Shopping_add_tower():
	emit_signal("add_tower")

func toggle_pause():
	get_tree().paused = not get_tree().paused


func _on_FastForward_pressed():
	emit_signal("next_wave")


func _on_Shopping_add_sheep():
	emit_signal("buy_sheep")

func _on_Shopping_add_field():
	emit_signal("buy_field")

func _on_BackToMenu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Startmenu.tscn")
	get_tree().paused = false


func _on_Shopping_add_laser_tower():
	emit_signal("add_laser_tower")

func hide_notifications():
	$Notification.visible = false

func show_notification(message):
	$Notification/Label.text = message
	$Notification.visible = true
	$Notification/Timer.start(2)