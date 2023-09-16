class_name ActionQueue extends Node

enum ACTION_TYPE {QUEUEABLE, CANCELABLE, UNCANCELABLE, MOVE_CHANNEL, MOVE}
var actionQueue = []
var actionRange = []
var actionTarget = []
var stop : Callable
var move : Callable

@onready var action = null
var qAction
signal channelAction(action)
signal channelActionComplete(action)
signal channelActionCancled(action)
signal act(action)
var channel = Timer.new()

func _ready():
	channel.name = "Channel"
	add_child(channel)
	channel = $Channel
	move = get_parent().move
	stop = get_parent().stop
	get_node("/root/World/InputHandler").keyReleased.connect(_on_key_released)
	channelAction.connect(get_parent()._on_channel)
	channelActionComplete.connect(get_parent()._on_channel_complete)
	channelActionCancled.connect(get_parent()._on_channel_cancel)
	action = null;
	qAction = null;

func clear():
	action = null;
	qAction = null;

func pushBack(actionNode):
	
	#if(actionNode.title != "move" && action!=null): # && actionNode.title == action.title ):
	#qwprint("return")
		#return

	if action == null || channel.is_stopped():
		action = actionNode
		if(action.actionType != ACTION_TYPE.MOVE_CHANNEL):
			stop.call()
	elif action.actionType == ACTION_TYPE.QUEUEABLE:
		qAction = actionNode
	elif action.actionType == ACTION_TYPE.CANCELABLE:
		if !channel.is_stopped():
			emit_signal("channelActionCancled", action)
			action._on_channel_cancled(action)
			channel.stop()
		action = actionNode
	elif(action.actionType == ACTION_TYPE.MOVE_CHANNEL && actionNode.actionType == ACTION_TYPE.MOVE):
		get_parent().target = actionNode.target
	#startAction()

func startAction():

	if action == null:
		return
	get_parent().look_at(action.target.position)
	if action.channel > 0:
		action._on_channel(action)
		emit_signal("channelAction", action)
		await startChannel()
		
	if(action == null):
		return
	emit_signal("act", action)
	action.action()
	action = qAction
	qAction=null
	
func startChannel():
	if action == null:
		return
	channel.wait_time = action.channel
	channel.start()
	await channel.timeout
	if action == null:
		return
	channel.stop()
	action._on_channel_complete(action)
	emit_signal("channelActionComplete", action)
	
func isInRange():
	return(action.range == -1 || get_parent().position.distance_to(action.target.position) <= action.range)

func _process(delta):
	if(action == null):
		return
	print(isInRange())
	if((isInRange() && channel.is_stopped())):
		startAction()
	elif(action != null && channel.is_stopped()):
		var moveTo = Node3D.new()
		moveTo.position = action.actor.position + action.actor.position.direction_to(action.target.position)
		move.call(moveTo)
	else:
		pass

func _on_key_released(key):
	if action && action.title == key && action.actionType == ACTION_TYPE.MOVE_CHANNEL:
		channel.stop()
		channel.emit_signal("timeout")


