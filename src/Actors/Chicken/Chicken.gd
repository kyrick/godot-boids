extends "res://src/Actors/Actor.gd"

var _flock: Array = []


func _on_FlockView_body_entered(body: PhysicsBody2D):
	_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody2D):
	var i = _flock.find(body)
	_flock.remove(i)


func _physics_process(delta):
	var center: = get_flock_center()
	if center != Vector2.INF:
		move_and_slide(get_direction(center) * speed)


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
