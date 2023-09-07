extends Area3D

var effect = ""
var collider = ""
var mesh = ""

var title = ""

var range = -1
var minRange = 1.2
var size = 1
var tarvelDistance = 5
var damage = 20
var speed = 99
var acceleration = 1
var growth = 0
var channel = 0.25
var cooldown = 1
var travelType = "fixed"
var tracking = true
var allyCast = false
var duration = 4
var actionType = 1
var cost = 10 #add to json
var length = 1
var width = 1

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

signal onHit(body)
signal atDest(dest)


func _ready():

	scale = Vector3(size,size,size)
	var shape = load(collider)
	#shape.radius = length
	shape.size = Vector3(width, .01, length)
	$CollisionShape3D.shape = shape
	print(collider)
	print(title)
	visible = false;
	active = false;
	targetNode = null;
	targetPlayer = null;
	self.body_entered.disconnect(_on_body_entered)

func endEffect():
	active = false;
	targetNode = null;
	targetPlayer = null;
	target = self;
	self.body_entered.disconnect(_on_body_entered)
	call_deferred("queue_free")

func setTarget(targetNode):
	target = targetNode

func action():
	if target == null:
		return
	startCD()
	setParamters()

func _physics_process(delta):
	#self.scale = scale * (60 * delta)
	if !active:
		rpc("sync",position, target.position, true)
		return
	look_at(dest, Vector3.UP)
	if tracking:
		dest = target.position
	travel.call(self, delta)
	rpc("sync",position, target.position)

func startCD():
	if(cooldown > 0):
		var cdTimer = Timer.new()
		cdTimer.wait_time = cooldown
		cdTimer.name = title+"CD"
		cdTimer.timeout.connect(get_parent()._on_cd_timeout.bind(cdTimer.name))
		get_parent().add_child(cdTimer)
		cdTimer.start()

func setParamters():
	get_parent().spawn(title, name, size)
	own = get_parent().get_parent()
	start = Vector3(own.position.x,1,own.position.z) 
	dest = target.position
	start += start.direction_to(dest) * minRange
	transform.origin = start
	visible = true;
	self.body_entered.connect(_on_body_entered)
	active = true;
	if duration > 0:
		$Duration.wait_time = duration
		$Duration.start()
	
	match travelType:
		"fixed":
			travel = get_node("/root/Global").fixedTravel
		"distance":
			travel = get_node("/root/Global").targetTravel
		"instant":
			travel = get_node("/root/Global").instantTravel

func startEffect(body = null):
	if(body != null):
		body.State.BaseStats.currentHealth = body.State.BaseStats.currentHealth - damage
	rpc("sync", position, target.position, true)
	endEffect()
	
func end():
	target.baseStats["moveSpeed"] = target.baseStats["moveSpeed"] / .20

func _on_body_entered(body : CharacterBody3D):
	if(body != own):
		startEffect(body)
		
func _on_duration_timeout():
	rpc("sync", position, target.position, true)
	endEffect()
	
@rpc() func sync(pos,targetPos, remove = false):
	pass

func fixedTravel(node):
	if(position.distance_to(start) > tarvelDistance && active ):
		startEffect()
		return Vector3.ZERO
	speed = speed*acceleration
	node.transform.origin += start.direction_to(dest) * speed

func targetTravel(node):
	if(position.distance_to(dest) < .1  && active):
		startEffect()
		return Vector3.ZERO
	speed = speed*acceleration
	node.transform.origin += position.direction_to(dest) * speed

func instantTravel(node):
	if !active:
		return Vector3.ZERO
	node.transform.origin = dest
	

	
