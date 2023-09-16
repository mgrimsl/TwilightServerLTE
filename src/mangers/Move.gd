extends Node

var target = null
var range = .2
var channel = 0
var actionType = 5
var cooldown = 0
var title = "move"
@onready var player = get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func action():
	
	player.State.MovementState["destination"] = target.position
	player.State["target"] = target
	player.State.MovementState["moving"] = true
