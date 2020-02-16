extends "res://src/Actors/Actor.gd"

export(float) var avoid_distance: = 100.0

var _flock: Array = []


func _on_FlockView_body_entered(body: PhysicsBody2D):
	_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody2D):
	var i = _flock.find(body)
	_flock.remove(i)


func _physics_process(delta):
	var center: = get_flock_center()
	if center != Vector2.INF:
		var avoid_dir = get_avoid_direction()
		var center_dir = get_direction(center)
		move_and_slide((avoid_dir + center_dir) * speed)


func get_direction(target: Vector2) -> Vector2:
	return global_position.direction_to(target)


func get_flock_center() -> Vector2:
	var center: = Vector2.INF
	if _flock.size():
		var total: = Vector2()
		for f in _flock:
			total += f.global_position
		center = total / _flock.size()
	return center


func get_avoid_direction() -> Vector2:
	var avoid_vector: = Vector2.ZERO
	
	for f in _flock:
		var neighbor_pos: Vector2 = f.global_position
		if global_position.distance_to(neighbor_pos) < avoid_distance:
			avoid_vector += global_position.direction_to(neighbor_pos) * -1
	
	return avoid_vector
