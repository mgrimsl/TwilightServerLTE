class_name Action extends Node3D 

@export var channel : float
@export var cooldown : float
#@export var maxRange : float
@export var range : float = -1
@export var title = "move"
@export var actionType : ActionQueue.ACTION_TYPE = ActionQueue.ACTION_TYPE.MOVE
@export var target : Node3D = Node3D.new()
@export var actor : Champion = Champion.new()

var qAct : Callable
func action():
	actor.destination = target.position
	actor.target = target
	actor.moving = true
