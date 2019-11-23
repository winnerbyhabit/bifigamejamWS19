extends Node2D

export var radius = 100

export(Color) var color

func _draw():
	draw_circle_custom(radius)
	
func draw_circle_custom(radius, maxerror = 0.25):

    if radius <= 0.0:
        return

    var maxpoints = 1024 # I think this is renderer limit

    var numpoints = ceil(PI / acos(1.0 - maxerror / radius))
    numpoints = clamp(numpoints, 3, maxpoints)

    var points = PoolVector2Array([])

    for i in numpoints:
        var phi = i * PI * 2.0 / numpoints
        var v = Vector2(sin(phi), cos(phi))
        points.push_back(v * radius)

    draw_colored_polygon(points, color)