extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var spawnpoint = Vector2(1,1)
export var destination = Vector2(500,150)

export var SPEED = 100
var path = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var navigation = get_parent().get_node("Navigation2D")
	path = navigation.get_simple_path(position, destination, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	#print(path)
	if(path.size() > 0):
		
		var next_position = path[0]
		print(next_position)
		if abs(position.x - next_position.x) + abs(position.y - next_position.y) <=1:
			path.remove(0)
		var direction = next_position-position 
		direction = direction.normalized()
		
		move_and_slide(direction * SPEED,Vector2(1,0))
		
