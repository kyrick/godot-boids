extends CollisionShape2D

func _ready():
	shape.radius = get_parent().get_parent().view_distance
