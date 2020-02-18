extends "res://src/Actors/Actor.gd"

export(float) var avoid_distance: = 20.0

var _flock: Array = []
var _mouse_target = Vector2.INF
var _velocity = Vector2()


func _ready():
	randomize()
	_velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * speed


func _on_FlockView_body_entered(body: PhysicsBody2D):
	if self != body:
		_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody2D):
	_flock.remove(_flock.find(body))


func _input(event):
	if event is InputEventMouseButton:
		_mouse_target = event.position


func _physics_process(_delta):
	var mouse_vector = Vector2.ZERO
	if _mouse_target != Vector2.INF:
		mouse_vector = global_position.direction_to(_mouse_target) * speed * max_force
	
	# get vectors to center, avoid, and alignment to flock
	var vectors = get_flock_status(_flock)
	
	# steer towards vectors
	var center_vector = vectors[0] * max_force
	var align_vector = vectors[1] * max_force
	var avoid_vector = vectors[2] * max_force

	var acceleration = align_vector + avoid_vector + center_vector + mouse_vector
	
	_velocity = (_velocity + acceleration).clamped(speed)
	
	_velocity = move_and_slide(_velocity)


func get_flock_status(flock: Array):
	var center_vector: = Vector2()
	var flock_center: = Vector2()
	var align_vector: = Vector2()
	var avoid_vector: = Vector2()
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position

		align_vector += f._velocity
		flock_center += neighbor_pos

		var d = global_position.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_position.direction_to(flock_center)
		var center_speed = speed * (global_position.distance_to(flock_center) / $FlockView/ViewRadius.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]
