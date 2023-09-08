extends Area3D

var effect = ""
var collider = ""
var mesh = ""

var title = ""

var range = -1
var minRange = 1.2
var size = 1
var travelDistance = 5
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
var startHeight = 1
var projectile = true

var target
var targetNode
var targetPlayer
var travel : Callable
var dest = Vector3()
var velocity = Vector3.ZERO
var start = Vector3()
var constantTravel = false
var own
var active = false

signal onHit(body)
signal atDest(dest)
signal durationEnd()


func _ready():
	dest = target.position
	if(effect != ""):
		var effectNode = Node.new()
		effectNode.set_script(load(effect))
		effectNode.ability = self
		add_sibling(effectNode)
		onHit.connect(effectNode._on_hit)
		atDest.connect(effectNode._at_dest)
		durationEnd.connect(effectNode._duration_end)
		
	scale = Vector3(size,size,size)
	var shape = load(collider)
	if (collider == "res://src/champions/projectiles/colliders/rectangle.tres"):
		shape.size = Vector3(width, .01, length)
	elif (collider == "res://src/champions/projectiles/colliders/sphere.tres"):
		shape.radius = width
	$CollisionShape3D.shape = shape
	visible = false;
	active = false;
	#targetNode = null;
	#targetPlayer = null;
	self.body_entered.disconnect(_on_body_entered)

func endEffect():
	rpc("sync", position, target.position, true)
	active = false;
	targetNode = null;
	targetPlayer = null;
	target = self;
	$Duration.stop()
	self.body_entered.disconnect(_on_body_entered)
	call_deferred("queue_free")

func setTarget(targetNode):
	target = targetNode

func doNothing(a,b):
	return true

func action():
	if target == null:
		return
	startCD()
	if projectile:
		setParamters()

func _physics_process(delta):
	if !active:
		return
	if tracking:
		dest = target.position
	if travel.call(self, delta) && $Duration.is_stopped():
		rpc("sync",position, dest, true)
		queue_free()
	if(dest != position):
		look_at(dest, Vector3.UP)
	rpc("sync",position, dest)


func startCD():
	if(cooldown > 0):
		var cdTimer = Timer.new()
		cdTimer.wait_time = cooldown
		cdTimer.name = title+"CD"
		cdTimer.timeout.connect(get_parent()._on_cd_timeout.bind(cdTimer.name))
		get_parent().add_child(cdTimer)
		cdTimer.start()

func setParamters():
	get_parent().spawn(title, name, size, length, width)
	own = get_parent().get_parent()
	start = Vector3(own.position.x,1,own.position.z) 
	print(dest)
	start += start.direction_to(dest) * minRange
	start.y = startHeight+.1
	if travelType == "instant":
		dest.y = startHeight+.1
		start = dest
	transform.origin = start
	look_at(dest, Vector3.UP)
	visible = true;
	self.body_entered.connect(_on_body_entered)
	active = true;
	if duration > 0:
		$Duration.wait_time = duration
		$Duration.start()
	
	match travelType:
		"distance":
			travel = get_node("/root/Global").distanceTravel
		"target":
			travel = get_node("/root/Global").targetTravel
		"instant":
			travel = doNothing
			#travel = get_node("/root/Global").instantTravel

func startEffect(body = null):
	if(body != null):
		body.State.BaseStats.currentHealth = body.State.BaseStats.currentHealth - damage
	rpc("sync", position, target.position, true)
	print("end")
	endEffect()
	
func end():
	target.baseStats["moveSpeed"] = target.baseStats["moveSpeed"] / .20

func _on_body_entered(body : CharacterBody3D):
	await emit_signal("onHit",body)
		
func _on_duration_timeout():
	$Duration.stop()
	emit_signal("durationEnd")
	
@rpc() func sync(pos,targetPos, remove = false):
	pass

func fixedTravel(node):
	if(position.distance_to(start) > travelDistance && active ):
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
	

	
