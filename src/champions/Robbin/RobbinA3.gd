extends Node

var player
var ability = null
var channel = false
var debuffTime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var aq = get_parent().get_parent().get_node("ActionQueue")
	aq.channelAction.connect(_on_channel)
	aq.channelActionComplete.connect(_on_channel_complete)
	player = get_parent().get_parent()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_channel(action):
	pass
func _on_channel_complete(action):
	player.move(action.target)
	player.transform.origin = action.dest
	queue_free()
func _on_hit(body):
	pass
func _at_dest(dest):
	pass
	#queue_free()
func _duration_end():
	pass
