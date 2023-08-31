extends Area3D

var damage = 5
var dest = Vector3()
var velocity = Vector3.ZERO
var start = Vector3()
var constantTravel = false
var travelDistance = 7
var speed = .3
var target

func init(pos, e):
	target = e
	start = Vector3(pos.x,1,pos.z)  
	dest = target.position
	start += start.direction_to(dest) * 1
	transform.origin = start
func _physics_process(_delta):
	dest = target.position
	if(constantTravel == true):
		fixedTravel()
	else:
		travel()

func fixedTravel():
	if(position.distance_to(start) > travelDistance ):
		call_deferred("queue_free")
		return
	velocity = start.direction_to(dest) * speed
	transform.origin += velocity

func travel():
	velocity = position.direction_to(dest) * speed
	transform.origin += velocity
func _on_body_entered(body):
	if body == target:
		#body.hit(damage, name, get_parent())
		call_deferred("queue_free")

