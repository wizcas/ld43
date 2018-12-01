extends Area2D

export (int) var min_desire = 20
export (int) var max_desire = 500
export (float) var fight_interval

var desire = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	desire = min_desire + randi() % (max_desire - min_desire)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func attack(target):
	target.hurt()
	pass
	
func eat(weight):
	desire -= weight
	if desire <= 0:
		satisfy()
	
func satisfy():
	queue_free()

func _on_Mob_area_entered(area):
	if area.is_in_group("servant"):
		print ('servant hit')
		attack(area)
		eat(area.meat_weight)
	if area.is_in_group("nino"):
		attack(area)
		satisfy()