extends Node

var target = null
var range = .2
var channel = 0
var type = 5

@onready var player = get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func action():
	#player.baseState["target"] = movTarget
	player.State.MovementState["destination"] = target.position
	player.look_at(target.position, Vector3.UP)
	player.State.MovementState["moving"] = true
