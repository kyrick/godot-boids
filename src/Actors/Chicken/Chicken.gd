extends "res://src/Actors/Actor.gd"

export(float) var avoid_distance: = 100.0

var _flock: Array = []
var _mouse_target = Vector2.INF
var _velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * speed

func _on_FlockView_body_entered(body: PhysicsBody2D):
	if self != body:
		_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody2D):
	_flock.remove(_flock.find(body))


func _input(event):
	if event is InputEventMouseButton:
		_mouse_target = event.position


func _physics_process(delta):
	var mouse_vector = Vector2.ZERO
	if _mouse_target != Vector2.INF:
		mouse_vector = global_position.direction_to(_mouse_target) * speed - _velocity
	
	var center_vector = get_center_vector(_flock)
	var avoid_vector = get_avoid_vector(_flock)
	var align_vector = align_to_flock(_flock, _velocity)
	
	var acceleration = align_vector + avoid_vector + center_vector
	
	_velocity = (_velocity + acceleration).clamped(speed)
	
	_velocity = move_and_slide(_velocity)


func align_to_flock(flock: Array, vector: Vector2) -> Vector2:
	var out: = Vector2()
	
	if flock.size():
		var flock_v: = Vector2()
		for f in flock:
			flock_v += f._velocity
		out = (flock_v / flock.size()) - vector
	
	return out


func get_center_vector(flock: Array) -> Vector2:
	var flock_center: = get_flock_center(flock)
	var center_speed = global_position.distance_to(flock_center)/ 100
	var center_vector = global_position.direction_to(flock_center) * center_speed
	return center_vector


func get_flock_center(flock: Array) -> Vector2:
	var center: = global_position
	if flock.size():
		var total: = Vector2()
		for f in flock:
			total += f.global_position
		center = total / flock.size()
	return center


func get_avoid_vector(flock: Array) -> Vector2:
	var avoid_vector: = Vector2.ZERO
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position
		if global_position.distance_to(neighbor_pos) < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position)
	
	return avoid_vector
