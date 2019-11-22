extends Node2D

var scene = load("res://TDGame/Goat.tscn")

export(String, FILE) var wavesTXT

var waves = []

var threshold = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if file.file_exists(wavesTXT):
		file.open(wavesTXT, file.READ)
		while !file.eof_reached():
			var csv = file.get_csv_line (" ")
			waves.push_back(csv)
		file.close()
	print(waves)
	set_process(true)

func _process(delta):
	threshold -= delta
	if threshold < 0:
		var befehl = waves.pop_front()
		if waves.size() > 0:
			if befehl[0] == "spawn":
				spawn_goat()
			elif befehl[0] == "pause":
				threshold += float(befehl[1])
		else:
			print('keine weiteren Schafe')
			set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_goat():
	var goat = scene.instance()
	add_child(goat)
	