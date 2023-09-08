extends Node

var actionQueue = []
var actionRange = []
var actionTarget = []
var stop : Callable
var move : Callable

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
signal channelAction(action)
signal channelActionComplete(action)
@onready var channel = $ChannelTimer
func _ready():
	action = null;
	qAction = null;

func pushBack(actionNode, targetNode = null):
	if targetNode == null:
		targetNode = actionNode.target
	#stop.call()
	if(actionNode.title != "move" && action!=null && actionNode.title == action.title ):
		return
	if action == null || channel.is_stopped():
		#add action
		action = actionNode
		if(action.actionType != get_node("/root/Global").MOVE_CHANNEL):
			stop.call()
	elif action.actionType == get_node("/root/Global").QUEUEABLE:
		#add qAction
		qAction = actionNode
	elif action.actionType == get_node("/root/Global").CANCELABLE:
		#ADD and Cancel
		channel.emit_signal("timeout")
		action = actionNode
		#cancel()
	elif(action.actionType == get_node("/root/Global").MOVE_CHANNEL && actionNode.actionType == get_node("/root/Global").MOVE):
		get_parent().State["target"] = actionNode.target


func addAction(aTarget, aRange, aAction, aChannel, aType, actionObj):
	pass
#	actionObj.action = aAction
#	actionObj.target = aTarget
#	actionObj.range = aRange
#	actionObj.channel = aChannel
#	actionObj.actionType = aType
func cancel():
	pass
#	action = null
#	qAction = null
#	channel.emit_signal("timeout")
#	channel.stop()

func act(a = action):
	#get_parent().look_at(action.target.position)
	get_parent().State["target"] = a.target
	
	if a.channel > 0:
		emit_signal("channelAction", action)
		get_parent().State.AttackState["channel"] = true
		await startChannel()
		
	if(action == null):
		return
	
		
	action.action.call()
	action = qAction
	qAction=null
func startChannel():
	channel.wait_time = action.channel
	channel.start()
	await channel.timeout
	channel.stop()
	emit_signal("channelActionComplete", action)
	get_parent().State.AttackState["channel"] = false
	
func isInRange():
	return(action.range == -1 || get_parent().position.distance_to(action.target.position) <= action.range)

func _physics_process(delta):
	if(action == null):
		return
	if(action.title == "move" || (isInRange() && channel.is_stopped())):
		act(action)
	elif(action != null && channel.is_stopped()):
		pass
		get_parent().move(action.target)
	else:
		pass


