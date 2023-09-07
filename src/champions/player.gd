extends CharacterBody3D

var parent
var champId
var AATimer : Timer
var AAWindUp : Timer
var A1Timer : Timer
var canCastA1 = true
var abilityHandler : Node
var actionQueue : Node
#this should be in state
#A1cd = 2
var channelQueue : Callable
var actionRange = .3

var moveSpeed = "moveSpeed"
var maxHealth = "maxHealth"
var attackSpeed = "attackSpeed"
var attackRange = "attackRange"
var windUpTime = "windUpTime"
var currentHealth = "currentHealth"
var destination = "destination"
var moving = "moving"
var pos = "position"
var attackMove = "attackMove"
var attacking = "attacking"
var channel = "channel"
var canAttack = "canAttack"
var target = "target"
var inAttackRange = "inAttackRange"
var State = {
	target : self,
	"BaseStats" : {
		moveSpeed: 1,
		maxHealth: 100,
		attackSpeed: 10,
		attackRange: 5,
		windUpTime: .2,
		currentHealth: 100
	},
 	"MovementState" : {
		destination : Vector3(1,1,1),
		moving : false,
		pos : position,
		attackMove : false
	},
	"AttackState" : {
		attacking : false,
		channel : false,
		canAttack : true,
		inAttackRange : false
	}
}

func _ready():
	preload("res://assets/icon.svg")
	$ActionQueue.move = move
	$ActionQueue.stop = stop
	parent = get_parent()
func getChampData():
	$GetChampData.getChampion(champId)
	
func _physics_process(delta):
	if(State.BaseStats.currentHealth <= 0):
		State.BaseStats.currentHealth = State.BaseStats.maxHealth
	if(position.distance_to(State[target].position) > .2):
		transform.origin += position.direction_to(State[target].position) * State.BaseStats[moveSpeed] * delta
		#move_and_slide()

func stop():
	State[target] = self
	State.MovementState[moving] = false
func move(movTarget = State[target]):
	State[target] = movTarget
	State.MovementState[destination] = movTarget.position
	State.MovementState[moving] = true
	
func setAttackingState(targetPlayer):
		pass
		#$ActionQueue.pushBack(targetPlayer, 5, $AbilityHandler.aac)

func updateBaseStats(data):
	State.BaseStats = data
	State.BaseStats[currentHealth] = State.BaseStats[maxHealth]

@rpc("any_peer") func _updateDest(id,targetVector):
	if id == str(multiplayer.get_remote_sender_id()):
		$TargetNode.position = targetVector
		$ActionQueue/Move.target = $TargetNode
		$ActionQueue.pushBack($ActionQueue/Move)
		State.AttackState[canAttack] = true
@rpc("any_peer") func updateState(State):
	pass

func _on_timer_timeout():
	State.MovementState[pos] = position
	
	rpc("updateState", State)
