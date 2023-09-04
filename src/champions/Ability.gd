extends Area3D

var type = null
var effect = ""
var collider = ""
var mesh = ""

var range = -1
var minRange = 1.2
var size = 1
var tarvelDistance = 5
var damge = 20
var speed = 99
var acceleration = 0
var growth = 0
var channel = 0.25
var cooldown = 1
var travelType = "fixed"
var tracking = true
var allyCast = false

var target
var targetNode
var targetPlayer
var travel : Callable
var dest = Vector3()
var velocity = Vector3.ZERO
var start = Vector3()
var constantTravel = false
var travelDistance = 7
var own
var active = false
@onready var timer : Timer = $DebuffTimer


func _ready():
	visible = false;
	active = false;
	targetNode = null;
	targetPlayer = null;
	target = null;
	self.body_entered.disconnect(_on_body_entered)
	#target=null
func action():
	if target == null:
		return
	get_parent().spawn(name)
	own = get_parent().get_parent()
	start = Vector3(own.position.x,1,own.position.z) 
	dest = target.position
	start += start.direction_to(dest) * minRange
	transform.origin = start
	visible = true;
	active = true;
	match travelType:
		"fixed":
			travel = fixedTravel
		"target":
			travel = targetTravel
	self.body_entered.connect(_on_body_entered)
		
func _physics_process(_delta):
	if !active:
		return
	if tracking:
		dest = target.position
	travel.call()

func fixedTravel():
	if(position.distance_to(start) > travelDistance && active ):
		startEffect()
		return
	velocity = start.direction_to(dest) * speed
	transform.origin += velocity
	rpc("sync",position, target.position)

func targetTravel():
	if(position.distance_to(dest) < .1  && active):
		startEffect()
		return
	velocity = position.direction_to(dest) * speed
	transform.origin += velocity
	rpc("sync",position, target.position)

func _on_body_entered(body : CharacterBody3D):
	if(body != own):
		startEffect(body)
		
func startEffect(body = null):
	if(body != null):
		body.State.BaseStats.currentHealth = body.State.BaseStats.currentHealth - damge
	rpc("sync", position, target.position, true)
	_ready()
	
func end():
	target.baseStats["moveSpeed"] = target.baseStats["moveSpeed"] / .20

	
func _on_debuff_timer_timeout():
	return
	timer.stop()
	_ready()
@rpc() func sync(pos,targetPos, remove = false):
	pass
	

