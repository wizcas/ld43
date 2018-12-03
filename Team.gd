extends Area2D

signal size_changed
signal nino_hp_changed
signal nino_dead
signal victory

export (PackedScene) var servant_gen
export (PackedScene) var food_gen
export (int) var y_offset = 30
export (int) var max_size = 8
export (int) var spawn_start_x = -100
export (int) var margin = 30
export (int) var slot_width = 100
export (float) var move_speed = 100

export (bool) var _is_debug

const GONE_HANDLER = '_on_Servant_gone'
const FEEDING_HANDLER = '_on_Servant_feeding'
const SACRIFICED_HANDLER = '_on_Servant_sacrificed'

var next_spawn_pos
var servants = []
var next_servant_index = 1
var cur_speed
var sacrificed_count = 0

func _enter_tree():
	next_spawn_pos = Vector2(spawn_start_x, 0)

func _ready():
	
#	position.y = vp_size.y - y_offset
#	set_y_offset(y_offset)
	position.y = get_node('../Ground').surface_world_y().y
	print('y: {0}'.format([position.y]))
	_notify_change()
	march()

func _process(delta):
	position.x += cur_speed * delta
	
	if _is_debug:
		if Input.is_action_just_pressed("ui_test"):
			spawn_servant()

func set_y_offset(offset):
	var vp_size = get_viewport_rect().size
	position.y = vp_size.y - offset
	
func nino():
	return $Nino
			
func size():
	return servants.size()
	
func tail():
	return spawn_start_x - size() * (slot_width + margin)

func recruit(s):
	if size() >= max_size:
		return
	s.follow()	
	call_deferred('_do_recruit', s)

func _do_recruit(s):
	print('recruiting')
	s.id = next_servant_index
	next_servant_index += 1
#	s.position = Vector2(_random_pick_x(size()), 0)
	if not s.is_connected('gone', self, GONE_HANDLER):
		s.connect('gone', self, GONE_HANDLER)
	if not s.is_connected('feeding', self, FEEDING_HANDLER):
		s.connect('feeding', self, FEEDING_HANDLER)
	if not s.is_connected('sacrificed', self, SACRIFICED_HANDLER):
		s.connect('sacrificed', self, SACRIFICED_HANDLER)
	s.get_parent().remove_child(s)
	add_child(s)
	s.goto(_random_pick_x(size()))
	servants.append(s)
	_notify_change()
	print('recruited')	

func spawn_servant():
	if size() >= max_size:
		return
	var s = servant_gen.instance()
	s.id = next_servant_index
	next_servant_index += 1
	s.follow()
	if not s.is_connected('gone', self, GONE_HANDLER):
		s.connect('gone', self, GONE_HANDLER)
	if not s.is_connected('feeding', self, FEEDING_HANDLER):
		s.connect('feeding', self, FEEDING_HANDLER)
	add_child(s)
	s.goto(_random_pick_x(size()))
	servants.append(s)
	_notify_change()

func _random_pick_x(i):
	return spawn_start_x - rand_range((slot_width + margin) * i, slot_width * (i + 1))
	
func _notify_change():
	print('servant count: ' + str(size()))
	emit_signal("size_changed", self, size(), tail())
	
func march():
	cur_speed = move_speed

func stop():
	cur_speed = 0
	
func attack():
	for member in get_children():
		print(str(member) + ' attack!')

func _on_Team_area_entered(area):
	if area.is_in_group('foe'):
		stop()

func _on_Team_area_exited(area):
	march()
	
func _on_Servant_gone(servant):
	var idx = servants.find(servant)
	if idx < 0:
		return
		
	servants.remove(idx)
	if idx < size():
		for i in range(size() - idx):
			servants[idx + i].goto(_random_pick_x(idx + i))
	_notify_change()
	
func _on_Servant_feeding(servant):
	print('feeding')
	var from = servant.position
	from.y += 64
	var to = $Nino.position
	to.y += 16
	var f = food_gen.instance()
	f.fly(from, to)
	add_child(f)
	
func _on_Servant_sacrificed():
	sacrificed_count += 1

func _on_Nino_hp_changed(hp):
	emit_signal('nino_hp_changed', hp)

func _on_Nino_dead():
	stop()
	emit_signal('nino_dead', sacrificed_count)

func _on_Nino_victory():
	stop()
	emit_signal('victory', sacrificed_count)
