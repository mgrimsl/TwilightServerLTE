extends CharacterBody3D

var parent

var champId

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var champData = {}
var AttackRange = 5
var AttackSpeed = 1
var WindUp = .1
var inAttackRange = false
var canAttack = true

var target
var autoAttackscn = preload("res://src/champions/auto_attack.tscn")
var AATimer : Timer
var AAWindUp : Timer

var Speed = 5
var MovementState = {
	"destination" : Vector3(1,1,1),
	"speed" : 5,
	"moving" : false,
	"position" : position,
	"attackMove" : false
}
var AttackState = {
	"attacking" : false,
	"inWindUp" : false
}
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _ready():
	parent = get_parent()
	AATimer = $AutoAttackTimer
	AAWindUp = $AutoAttackWindUpTimer
	champData = $GetChampData.getChampion(champId)
	
	
func _physics_process(delta):

	if(target!=null):
		MovementState["destination"] = target.position
	setCanAttack()
	if MovementState["attackMove"]:
		MovementLoop(delta, AttackRange)
	else:
		MovementLoop(delta,.1)

func setCanAttack():
	if target != null && position.distance_to(target.position) <= AttackRange:
		inAttackRange = true
	elif target != null && !AttackState["inWindUp"]:
		inAttackRange = false
		MovementState["attackMove"] = true
		move()
	if inAttackRange && canAttack && target!=null:
		startWindUp()

func MovementLoop(delta, movRange):
	if(MovementState["moving"] == false || position.distance_to(MovementState["destination"]) <= movRange):
		MovementState["moving"] = false
		return
	velocity = position.direction_to(MovementState["destination"]) * Speed
	move_and_slide()

func startWindUp():
	AttackState["inWindUp"] = true
	look_at(MovementState["destination"], Vector3.UP)
	AAWindUp.wait_time = WindUp
	AAWindUp.start()
	#stop()
	canAttack = false
	rpc("updateAttk", AttackState)
	
func creatAttackObjects():
	AATimer.wait_time = AttackSpeed
	AATimer.start()
	canAttack = false
	var autoAttack = autoAttackscn.instantiate()
	autoAttack.init(position,target)
	add_sibling(autoAttack)
	rpc("attack", target.name, MovementState)

func stop():
	MovementState["moving"] = false
func move():
	MovementState["moving"] = true
	
func setAttackingState(targetPlayer):
	MovementState["destination"] = targetPlayer.position
	MovementState["moving"] = true
	MovementState["attackMove"] = true
	target = targetPlayer
func sendChampDataToClient(data):
	rpc("sendChampData", data)
	
	
@rpc("any_peer") func _updateDest(id,dest):
	if id == str(multiplayer.get_remote_sender_id()):
		MovementState["destination"] = dest
		MovementState["moving"] = true
		MovementState["attackMove"] = false
		target = null
		
@rpc("any_peer") func _attacked(target):
	var subject = multiplayer.get_remote_sender_id()
	parent.attack(target, subject)
	print(subject ," attacked ",target)
			
@rpc("any_peer") func attack(_target, _MovementState):
	pass
@rpc("any_peer") func updateState(_id,State):
	pass
@rpc("reliable", "any_peer") func sendChampData(champData):
	pass
func _on_auto_attack_timer_timeout():
	canAttack = true
	AATimer.stop()
	
func _on_auto_attack_wind_up_timer_timeout():
	AttackState["inWindUp"] = false
	AAWindUp.stop()
	if target != null:
		creatAttackObjects()
	else:
		canAttack = true
func _on_timer_timeout():
	MovementState["position"] = position
	rpc("updateState", self.name, {"MovementState": MovementState, "AttackState" : AttackState})
