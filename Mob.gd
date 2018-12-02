extends Area2D

export (int) var min_desire = 20
export (int) var max_desire = 500
export (float) var fight_interval

var desire = 0
var sprite_pool = [
	{
		'desire': 200,
		'mobs': ['husky'],
	},
	{
		'desire': 500,
		'mobs': ['kuma'],
	}
]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var ground = get_node('../Ground')
	position.y = ground.surface_world_y().y
	desire = min_desire + randi() % (max_desire - min_desire)
	update_bubble()
	$Sprite.texture = get_sprite()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_sprite():
	sprite_pool.sort_custom(self, 'sort_pool')
	var tex = null
	for sprite_conf in sprite_pool:
		if desire <= sprite_conf.desire:
			tex = sprite_conf.mobs[randi() % sprite_conf.mobs.size()]
			break
	if tex == null:
		print('NULL MOB SPRITE!!!!! (desire: {0})'.format([desire]))
		return
	var path = 'res://sprites/foe/{0}.png'.format([tex])
	print('Mob sprite: {0}'.format([path]))
	return load(path)
			
func sort_pool(a,b):
	return a.desire < b.desire

func attack(target):
	target.hurt()
	$Anim.play("attack")
	pass
	
func eat(weight):
	desire -= weight
	update_bubble()
	if desire <= 0:
		satisfy()
	
func satisfy():
	queue_free()
	
func update_bubble():
	$Bubble/Container/Text.text = '{0}kg wanted'.format([desire])

func _on_Mob_area_entered(area):
	print('{0}: {1}'.format([area.name, area.get_groups()]))
	if area.is_in_group("servant"):
		print ('servant hit')
		attack(area)
		eat(area.meat_weight)
	if area.is_in_group("nino"):
		attack(area)
		satisfy()

func _on_Anim_animation_finished(anim_name):
	if anim_name == 'attack':
		$Anim.play("idle")
