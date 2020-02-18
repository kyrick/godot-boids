extends Node2D

export(int) var boids = 20
export(PackedScene) var Boid

var _width = ProjectSettings.get_setting("display/window/size/width")
var _height = ProjectSettings.get_setting("display/window/size/height")


func _ready():
	for _i in range(boids):
		randomize()
		var boid = Boid.instance()
		boid.position = Vector2(rand_range(0, _width), rand_range(0, _height))
		add_child(boid)
