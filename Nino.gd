extends Area2D
signal hp_changed
signal dead
signal victory

export (int) var max_hp = 5
export (int) var initial_meat_weight = 4

onready var anim = $Anim

var meat_weight = 0
var hp

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	hp = max_hp
	_notify_hp_changed()
	meat_weight = initial_meat_weight
	anim.play("walk")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func hurt():
	hp -= 1
	_notify_hp_changed()
	$SfxHurt.play()
	if hp <= 0:
		die()
		
func eat():
	if(hp >= max_hp):
		return
	hp += 1
	$SfxEat.play()
	_notify_hp_changed()
		
func die():
	print('game over')
	emit_signal('dead')
	queue_free()
	
func _notify_hp_changed():
	emit_signal('hp_changed', hp)	

func _on_Nino_area_entered(area):
	print('area: {0}'.format([area.name]))
	if area.is_in_group('food'):
		area.consume()
		eat()
	if area.is_in_group('servant') and not area.is_following:
		get_node('..').recruit(area)
	if area.is_in_group('goal'):
		emit_signal('victory')
