extends Node

const QUEUEABLE = 1
const CANCELABLE = 2
const UNCANCELABLE = 3
const MOVE_CHANNEL = 4
const MOVE = 5
const INSTANT = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func instanceNode(node_scn :PackedScene, parent, location = Vector3(0,1,0)):
	var node_instance = node_scn.instantiate()
	node_instance.transform.origin = location
	parent.add_child(node_instance)
	return node_instance
