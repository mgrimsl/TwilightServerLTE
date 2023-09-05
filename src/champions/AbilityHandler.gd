extends Node
var channelQueue : Callable
var abilityScn = preload("res://src/champions/Ability.tscn")
var abilityData

var A1CD = "A1CD"
var A2CD = "A2CD"
var A3CD = "A3CD"
var A4CD = "A4CD"

func _physics_process(_delta):

	if(has_node(A1CD)):
		rpc("cooldown", "A1", int(get_node(A1CD).time_left)+1)
	if(has_node(A2CD)):
		rpc("cooldown", "A2", int(get_node(A2CD).time_left)+1)
	if(has_node(A3CD)):
		rpc("cooldown", "A3", int(get_node(A3CD).time_left)+1)
	if(has_node(A4CD)):
		rpc("cooldown", "A4", int(get_node(A4CD).time_left)+1)
# Called when the node enters the scene tree for the first time.
func loadAbilities(data):
	abilityData = data

func instanceAbility(abilityName):
	var ability = abilityScn.instantiate()
	var aData = abilityData[abilityName]
	ability.title = abilityName
	for prop in aData:
		ability.set(prop, aData[prop])
	return ability
func addAbility(abilityInstance):
	add_child(abilityInstance, true)
	
func spawn(abilityTitle, nodeName, size):
	rpc("spawnAbility",abilityTitle, nodeName, size)

func _on_cd_timeout(name):
	rpc("cooldown", str(name.split("C")[0]), 0, true)
	var timer = get_node(str(name))
	timer.stop()
	set(name+"CD", null)
	timer.queue_free()
	
		
@rpc() func cooldown(title, timeleft, timeout=false):
	pass
@rpc() func spawnAbility(name, nodeName, size):
	pass
