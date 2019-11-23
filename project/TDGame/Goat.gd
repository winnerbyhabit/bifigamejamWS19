extends KinematicBody2D



export var lifepoints = 5

export var destination = Vector2(500,150)

var is_alive = true

signal win
signal loose

export var SPEED = 100
var path = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var navigation = get_parent().get_node("Navigation2D")
	path = navigation.get_simple_path(position, destination, false)

func win():
	emit_signal("win")
	queue_free()

func loose():
	if self.is_alive:
		$die.play()
		emit_signal("loose")
		set_process(false)
		self.is_alive = false
		#self.visible = false
		$CollisionShape2D.disabled = true

func damage(damage_points):
	lifepoints -= damage_points
	if lifepoints < 0:
		loose()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	
	#print(path)
	if(path.size() > 0):
		
		var next_position = path[0]
		if abs(position.x - next_position.x) + abs(position.y - next_position.y) <=8:
			path.remove(0)
		var direction = next_position-position 
		direction = direction.normalized()
		
# warning-ignore:return_value_discarded
		move_and_slide(direction * SPEED,Vector2(1,0))
	else:
		set_process(false)
		win()


