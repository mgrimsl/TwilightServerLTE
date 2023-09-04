extends Node
var target
var activeAbility
var channelQueue : Callable

var canAA = true
var canA1 = true
# Called when the node enters the scene tree for the first time.
func loadAbilities(data):
	for key in data:
		if data[key]["type"] == null:
			continue
		#TODO: LOAD EFFECT SCRIPT
		#var ability = load(data[key]["type"])
		var ability = get_node(key)
		for propName in data[key]:
			ability.set(propName, data[key][propName])
		add_child(ability)
	
func spawn(abilityName):
	rpc("spawnAbility",abilityName)
	
@rpc() func spawnAbility(name):
	pass
