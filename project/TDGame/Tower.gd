extends Node2D

export var firerate = 2

export var range_upgrade = 20
export var tower_range = 100
export var tower_damage = 1
export var max_targets = 100
export var is_lasertower = false
export(Color) var laser_color

var current_targets = []
var fire_threshold  = firerate
var shooting_allowed = true
signal tower_fired
signal tower_upgraded


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://assets/Tower_1.png")
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
	if shooting_allowed:
		if fire_threshold <= 0:
			var shoot = false
			var counter = 0
			for target in current_targets:
				counter += 1
				if counter > max_targets:
					continue
				if is_instance_valid( target ) and target.is_alive:
					target.damage(tower_damage)
					shoot = true
				else:
					current_targets.remove(current_targets.find(target))
				
				var line = Line2D.new()
				line.add_point(Vector2(0,0))
				line.add_point(target.position - position)
				line.add_to_group('laser')
				line.default_color = laser_color
				line.width = 5
				$Timer.start(0.1)
				add_child(line)
				
				
			if shoot:
				fire_threshold += firerate
				if not is_lasertower:
					$Animation.set_frame(0)
					$Animation.play("attack")
				
				
				$Animation.visible = true
			emit_signal("tower_fired",current_targets.size())
		else:
			fire_threshold -= delta

func tidy_up_lazors():
	var children = get_children()
	for c in children:
		if c.is_in_group("laser"):
			c.queue_free()
		

func _on_Animation_animation_finished():
	$Animation.visible = false

func show_tower_upgrade(value):
	$Upgrade.visible = value

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			show_tower_upgrade(true)

func enable_shooting(value):
	shooting_allowed = value

func set_lasertower():
	max_targets = 1
	is_lasertower = true

func upgrade_tower():
	if get_parent().get_parent().is_there_money_for_tower():
		tower_range += range_upgrade 
		$Animation.scale *= float(tower_range)/(tower_range-range_upgrade)
		
		$Area2D/CollisionShape2D.shape.set_radius(tower_range)
		$Circle.radius = tower_range
		$Circle.update()
		emit_signal("tower_upgraded")
	
