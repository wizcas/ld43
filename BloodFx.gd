extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Timer.wait_time = lifetime + 0.1
	$Timer.start()
	print('boom')
	emitting = true

func _on_Timer_timeout():
	queue_free()
