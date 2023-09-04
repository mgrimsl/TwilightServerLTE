extends Node

var actionQueue = []
var actionRange = []
var actionTarget = []
var stop : Callable
var move : Callable
var pQ
const QUEUEABLE = 1
const CANCELABLE = 2
const UNCANCELABLE = 3
const MOVE_CHANNEL = 4
const MOVE = 5
const INSTANT = 0
var action = {
	"action": null,
	"target": null,
	"range": null,
	"channel": null,
	"actionType": null
	}
var qAction = {
	"action": null,
	"target": null,
	"range": null,
	"channel": null,
	"actionType": null
	}
@onready var channel = $ChannelTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	action = {};
	qAction = {};
	#pQ = $PriorityQueue.PriorityQueue.new([])
func pushBack(actionNode):
	stop.call()
	if action == null || channel.is_stopped():
		#add action
		addAction(actionNode.target, actionNode.range, actionNode.action, actionNode.channel, actionNode.type, action)
	elif action.actionType == QUEUEABLE:
		#add qAction
		addAction(actionNode.target, actionNode.range, actionNode.action, actionNode.channel, actionNode.type, qAction)
	elif action.actionType == CANCELABLE:
		#ADD and Cancel
		addAction(actionNode.target, actionNode.range, actionNode.action, actionNode.channel, actionNode.type, action)
		cancel()
	elif(action.actionType == MOVE_CHANNEL && actionNode.type == MOVE):
		addAction(actionNode.target, actionNode.range, actionNode.action, actionNode.channel, actionNode.type, qAction)
		act(qAction)

func addAction(aTarget, aRange, aAction, aChannel, aType, actionObj):
	actionObj.action = aAction
	actionObj.target = aTarget
	actionObj.range = aRange
	actionObj.channel = aChannel
	actionObj.actionType = aType
func cancel():
	action = {}
	qAction = {}
	channel.emit_signal("timeout")
	channel.stop()

func act(a = action):
	get_parent().look_at(action.target.position)
	get_parent().State.MovementState["destination"] = action.target.position
	if a.channel > 0:
		get_parent().State.AttackState["channel"] = true
		await startChannel()
		get_parent().State.AttackState["channel"] = false
	if(action.is_empty()):
		return
	a.action.call()
	action = qAction
	qAction={}
func startChannel():
	channel.wait_time = action.channel
	channel.start()
	await channel.timeout
	channel.stop()
func clear():
	action = {}
	qAction = {}
	channel.emit_signal("timeout")
	channel.stop()
	
func isInRange():
	return(action.range == -1 || get_parent().position.distance_to(action.target.position) <= action.range)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(!action.is_empty() && isInRange() && channel.is_stopped()):
		act(action)
		stop.call()
	elif(!action.is_empty() && channel.is_stopped()):
		move.call(action.target)
	else:
		pass

		
