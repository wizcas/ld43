extends Area2D

signal feeding
signal gone
signal sacrificed

export (PackedScene) var bloodfx
export (int) var min_food = 0
export (int) var max_food = 2
export (int) var min_weight = 40
export (int) var max_weight = 200
export (int) var charge_speed = 300

var id = -1
var food = 0
var meat_weight = 0
var chr_name = ''
var is_charging = false
var mouse_over = false
var to_x = null
var is_following = false

func _ready():
	food = min_food + randi() % (max_food - min_food)
	meat_weight = min_weight + randi() % (max_weight - min_weight)
	chr_name = 'Servant'
#	if to_x == null:
#		to_x = position.x	
	connect("mouse_entered",self,"_mouse_over", [true])
	connect("mouse_exited",self,"_mouse_over", [false])
	set_process_unhandled_input(true)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if not is_following:
		return
	if is_charging:
		position.x += charge_speed * delta
	elif to_x != position.x and abs(to_x - position.x) > 1:
		position.x = lerp(position.x, to_x, delta * 5)	
	else:
		position.x = to_x

func follow():
	is_following = true
	position = Vector2(0,0)
	$Anim.play("walk")

func goto(x):
	to_x = x

func feed():
	print('feeding: ' + str(food))
	if food <= 0:
		return
	food -= 1
	emit_signal("feeding", self)

func charge():
	print('CHARGE!: ' + chr_name)
	# CHARGE!
	is_charging = true
	$Anim.play("charge")
	$SfxCharge.play()
	emit_signal("gone", self)
	
func hurt():
	# play death anim & fx & sfx, etc.
	var fx = bloodfx.instance()
	fx.position = position + Vector2(0,-1) * $CollisionShape2D.shape.height * 1 + Vector2(1, 0) * 32
	get_node('..').add_child(fx)
	emit_signal('sacrificed')
	queue_free()
	
func dismiss():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	if is_charging:
		dismiss()

func _mouse_over(over):
    self.mouse_over = over
	
func _unhandled_input(event):
	if not is_charging and mouse_over and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		get_tree().set_input_as_handled()
		charge()
