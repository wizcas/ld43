extends Area2D

export (int) var speed = 200
export (int) var height = 128
export (Vector2) var angular_range = Vector2(180, 720)

var initial_pos
var to_pos
var distance_x = 0
var angular_speed

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	initial_pos = position
	angular_speed = deg2rad(rand_range(angular_range.x, angular_range.y))
	print ('angular speed: {0}'.format([angular_speed]))

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if distance_x == 0:
		return
	var x = position.x + delta * speed
	var t = float(x - initial_pos.x) / distance_x
	if t == 1:
		return
	var y = -sin(t * PI) * height - lerp(initial_pos.y, to_pos.y, t)
	position = Vector2(x,y)
	rotate(angular_speed * delta)

func consume():
	queue_free()
	
func fly(from, to):
	position = from
	to_pos = to
	distance_x = to.x - from.x	