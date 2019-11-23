extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var tower_range = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.shape.set_radius(tower_range)
	$Circle.radius = tower_range
	pass # Replace with function body.

func show_tower_range(value):
	$Circle.visible = value

