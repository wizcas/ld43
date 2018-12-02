extends Node

export (PackedScene) var mob_gen
export (int) var distance = 500
export (int) var mob_start_distance = 10
export (int) var mob_end_distance = 20
export (int) var min_mob_margin = 10
export (int) var max_mob_margin = 30

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	gen_ground()
	gen_mobs()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	print('i\'m @ {0}'.format([cur_distance()]))
	pass

func meter2x(meter):
	return meter * $Ground.meter()
	
func x2meter(x):
	return x / $Ground.meter()

func gen_ground():
	$Ground.gen(distance)
	
func calc_next_mob_x(prev_mob_x):
	var rnd = int(rand_range(min_mob_margin, max_mob_margin))
	return prev_mob_x + rnd
	
func gen_mobs():
	var next_mob_x = calc_next_mob_x(mob_start_distance)
	var i = 0
	while next_mob_x < distance - mob_end_distance:
		var m = mob_gen.instance()
		m.position.x= meter2x(next_mob_x)
		print('mob {0} @ {1} ({2})'.format([i, next_mob_x, m.position]))
		add_child(m)
		next_mob_x = calc_next_mob_x(next_mob_x)
		i += 1

func cur_distance():
	return x2meter($Team.position.x)