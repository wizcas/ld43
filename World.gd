extends Node

export (PackedScene) var mob_gen
export (PackedScene) var servant_gen
export (int) var distance = 500
export (int) var mob_start_distance = 10
export (int) var mob_end_distance = 20
export (int) var min_mob_margin = 10
export (int) var max_mob_margin = 30
export (int) var min_servant_margin = 5
export (int) var max_servant_margin = 10
export (int) var servant_possibility = 0.5

var mob_meter_list = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	gen_ground()
	gen_mobs()
	gen_servants()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	print('i\'m @ {0}'.format([cur_distance()]))
	pass

func meter2x(meter):
	return meter * $Ground.meter()
	
func x2meter(x):
	return x / $Ground.meter()
	
func rnd_meter(min_val, max_val):
	return int(rand_range(min_val, max_val))

func gen_ground():
	$Ground.gen(distance)
	
func gen_mobs():
	var mob_meter = mob_start_distance + rnd_meter(min_mob_margin, max_mob_margin)
	var i = 0
	while mob_meter < distance - mob_end_distance:
		mob_meter_list.append(mob_meter)
		var m = mob_gen.instance()
		m.position.x= meter2x(mob_meter)
		print('mob {0} @ {1} ({2})'.format([i, mob_meter, m.position]))
		add_child(m)
		mob_meter += rnd_meter(min_mob_margin, max_mob_margin)
		i += 1
		
func gen_servants():
	for i in range(mob_meter_list.size() - 1):
		var mob_meter = mob_meter_list[i]
		var spacing = mob_meter_list[i+1] - mob_meter
		var servant_meter = rnd_meter(min_servant_margin, max_servant_margin)
		while servant_meter < spacing:
			if randf() <= servant_possibility:				
				var s = servant_gen.instance()
				s.position.x = meter2x(servant_meter + mob_meter)
				s.position.y = $Ground.surface_world_y().y
	#			print('servant {0} @ {1} ({2})'.format([i, servant_meter, s.position]))
				add_child(s)
			servant_meter += rnd_meter(min_servant_margin, max_servant_margin)

func cur_distance():
	return x2meter($Team.position.x)