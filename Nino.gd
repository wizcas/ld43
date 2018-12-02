extends Area2D

export (int) var hp = 5
export (int) var initial_meat_weight = 4

onready var anim = $Anim

var meat_weight = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	meat_weight = initial_meat_weight
	anim.play("walk")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func hurt():
	hp -= 1
	print("Nino's HP: " + str(hp))
	if hp <= 0:
		die()
		
func die():
	print('game over')
	queue_free()

func _on_Nino_area_entered(area):
	if area.is_in_group('food'):
		area.consume()
