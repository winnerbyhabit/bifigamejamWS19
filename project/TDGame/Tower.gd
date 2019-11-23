extends Node2D

export var firerate = 2

export var tower_range = 100
export var tower_damage = 1
var current_targets = []
var fire_threshold  = firerate

signal tower_fired

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.shape.set_radius(tower_range)
	$Circle.radius = tower_range
	$Reloadbar.max_value = firerate

func show_tower_range(value):
	$Circle.visible = value
	#print('value')


func target_entered(body):
	if body.is_in_group("goat"):
		current_targets.append(body)


func target_exited(body):
	if body.is_in_group("goat"):
		if body.is_alive:
			current_targets.remove(current_targets.find(body))

func _process(delta):
	$Reloadbar.value = firerate - fire_threshold
	if fire_threshold <= 0:
		var shoot = false
		for target in current_targets:
			if is_instance_valid( target ) and target.is_alive:
				target.damage(tower_damage)
				shoot = true
			else:
				current_targets.remove(current_targets.find(target))
	
		if shoot:
			fire_threshold += firerate
		emit_signal("tower_fired",current_targets.size())
	else:
		fire_threshold -= delta