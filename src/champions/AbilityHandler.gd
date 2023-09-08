extends Node
var channelQueue : Callable
var abilityScn = preload("res://src/champions/projectiles/Ability.tscn")
var abilityData ={}

var A1CD = "A1CD"
var A2CD = "A2CD"
var A3CD = "A3CD"
var A4CD = "A4CD"

func _ready():
	get_parent().get_parent().get_parent().get_node("InputHandler").keyReleased.connect(_on_key_released)

func _physics_process(_delta):

	if(has_node(A1CD)):
		rpc_id(int(str(get_parent().name)),"cooldown", "A1", int(get_node(A1CD).time_left)+1)
	if(has_node(A2CD)):
		rpc_id(int(str(get_parent().name)),"cooldown", "A2", int(get_node(A2CD).time_left)+1)
	if(has_node(A3CD)):
		rpc_id(int(str(get_parent().name)),"cooldown", "A3", int(get_node(A3CD).time_left)+1)
	if(has_node(A4CD)):
		rpc_id(int(str(get_parent().name)),"cooldown", "A4", int(get_node(A4CD).time_left)+1)
# Called when the node enters the scene tree for the first time.
func loadAbilities(abilities):
	for ability in abilities:
		abilityData[ability["title"]] = ability 
		
	#abilityData = data

func instanceAbility(abilityName):
	var ability = abilityScn.instantiate()
	var aData = abilityData[abilityName]
	ability.title = aData["title"]
	for prop in aData:
		ability.set(prop, aData[prop])
	return ability
func addAbility(abilityInstance):
	add_child(abilityInstance, true)
	
func spawn(abilityTitle, nodeName, size, length, width):
	rpc("spawnAbility",abilityTitle, nodeName, size, length, width)

func _on_cd_timeout(name):
	rpc("cooldown", str(name.split("C")[0]), 0, true)
	var timer = get_node(str(name))
	timer.stop()
	set(name+"CD", null)
	timer.queue_free()

func _on_key_released(key):
	if abilityData[key]["chargeable"]:
		get_parent().get_node("ActionQueue").channel.emit_signal("timeout")
		
@rpc() func cooldown(title, timeleft, timeout=false):
	pass
@rpc() func spawnAbility(name, nodeName, size, length, width):
	pass
