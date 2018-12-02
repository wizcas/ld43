extends Node2D

export (int) var offset_x_min = 100
export (int) var offset_x_max = 300

onready var _tween = $Tween
onready var _cam = $Cam

var initial_vp_size
var easing = Tween.EASE_OUT
var transition = Tween.TRANS_SINE

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	initial_vp_size = get_viewport_rect().size

func _on_Team_size_changed(team, size, tail):
	setPos(team, size, tail)
	
func setPos(team, size, tail):
	var ratio = float(size) / team.max_size
	var offset = lerp(offset_x_min, offset_x_max, ratio)
	var newzoom = abs(tail) / offset
	var newx = tail
	var newy = -initial_vp_size.y * (newzoom-1)
#	_cam.offset.y = -team.position.y
#	var newy = -team.position.y
#	var newy = 0
	var newpos = Vector2(newx, newy)
#	print('newzoom: {0}, newx: {1}, newy: {2}'.format([newzoom, newx, newy]))
	var distance = (newpos - position).length()	
	var tween_time = sqrt(distance / _cam.smoothing_speed) / 10	
#	print('distance: {0}, tween time: {1}'.format([distance, tween_time]))	
	var need_active = false
	if _cam.zoom.x != newzoom:
		_tween.interpolate_property(_cam, "zoom", _cam.zoom, Vector2(1,1) * newzoom, tween_time, transition,easing)
		need_active = true
	if position != newpos:
		_tween.interpolate_property(self, "position", position, newpos, tween_time, transition,easing)
		need_active = true	
	if need_active and not _tween.is_active():
		_tween.start()
	