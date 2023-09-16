class_name Projectile extends Area3D

enum TRAVEL_TYPE {FIXED_DISTANCE, TARGET, INSTANT}
@export var collider : PackedScene = preload("res://src/champions/projectiles/colliders/sphere.tscn")
@export var base : bool = true
@export var length : float = 1.0
@export var width : float = .1

@export var minRange : float = 1.2
@export var travelDistance : float = 5.0
@export var speed : float = 18.0
@export var acceleration : float = 1.0
@export var travelType : TRAVEL_TYPE = TRAVEL_TYPE.FIXED_DISTANCE
@export var tracking : bool = false
@export var duration : float = 4.0

var travel : Callable
var target : Node3D
var actor : Node3D
var dest : Vector3
var start : Vector3 

signal onHit(proj, body)
signal atDest(proj, dest)
signal zoneLeft(proj, dest)

func _init():
	if base:
		visible = false
		return
	top_level = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if base:
		return
	top_level = true
	setStartAndTarget()
	look_at(dest)
	setTravel()
	setCollider()

func setStartAndTarget(actor = self.actor, target = self.target):
	self.start = actor.position
	self.start.y = target.position.y
	self.start += start.direction_to(target.position) * minRange
	if(travelType == TRAVEL_TYPE.FIXED_DISTANCE):
		self.dest = start + start.direction_to(target.position) * travelDistance
	else:
		dest = target.position
	position = start
	if travelType == TRAVEL_TYPE.INSTANT:
		look_at(dest)
		transform.origin = dest


func setCollider():
	var c = collider.instantiate()
	if "shape" in c:
		if "radius" in c.shape:
			c.shape = SphereShape3D.new()
			c.shape.radius = width
		if "size" in c.shape:
			c.shape = BoxShape3D.new()
			c.shape.size = Vector3(width, 1, length)
	add_child(c)

func setTravel():
	match travelType:
		TRAVEL_TYPE.FIXED_DISTANCE:
			travel = fixedDistanceTravel
		TRAVEL_TYPE.TARGET:
			travel = targetTravel
		TRAVEL_TYPE.INSTANT:
			travel = instantTravel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if base:
		return
	if tracking:
		dest = target.position
	if position.distance_to(dest) > 0:
		look_at(dest)
		travel.call(delta)
	else:
		pass
	
func fixedDistanceTravel(delta):
	if(position.distance_to(start) >= travelDistance):
		emmitAtDest()
		return
	speed = speed * acceleration
	transform.origin += start.direction_to(dest) * speed * delta

func targetTravel(delta):
	if(position.distance_to(dest) < .2):
		emmitAtDest()
		return
	speed = speed*acceleration
	transform.origin += position.direction_to(dest) * speed * delta

func instantTravel(delta):
	if dest == transform.origin:
		return
	transform.origin = dest
	emmitAtDest()
	
func emmitAtDest():
	emit_signal("atDest", self, dest)

func _on_body_entered(body):
	emit_signal("onHit", self, body)

func _on_body_exited(body):
	emit_signal("zoneLeft", self, body)
