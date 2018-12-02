extends PanelContainer

onready var weightVal = $Items/Weight/Value
onready var foodVal = $Items/Food/Value
onready var feedButton = $Items/FeedButton

var servant

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	update()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	update()
		
func update():
	if servant == null:
		return
	weightVal.text = '{0}kg'.format([servant.meat_weight])
	foodVal.text = 'x {0}'.format([servant.food])
	feedButton.disabled = servant.food <= 0

func _on_SacrificeButton_pressed():
	if servant == null:
		return
	servant.charge()

func _on_FeedButton_pressed():
	if servant == null:
		return
	servant.feed()
