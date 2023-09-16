class_name BasicAttack extends Ability
var stop = false

func _ready():
	super()
	$"../ActionQueue".channelAction.connect(stop_auto_attack)
	$"../ActionQueue".act.connect(stop_auto_attack)

func action():
	super()
	stop = false
	var AQ = actor.get_node("ActionQueue")
	await get_tree().create_timer(cooldown).timeout
	if stop:
		return
	AQ.pushBack(self)
	
func stop_auto_attack(action):
	#print(action)
	if(action != self):
		stop = true
	
