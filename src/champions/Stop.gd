extends Node
var target = null
const range = .1
var channel = 0
var type = null
@onready var player = get_parent().get_parent()
func stop():
	player.State["target"] = self
	player.State.MovementState["moving"] = false
