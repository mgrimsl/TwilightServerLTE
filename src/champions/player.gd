class_name Champion extends  CharacterBody3D

@export var moveSpeed = 5.0

@export var maxHealth = 200
@export var currentHealth = 200

@export var destination = Vector3(-1,1,-1)
@export var moving = false
@export var channel = false
@export var stunned = false

var champId
var canCastA1 = true
var abilityHandler : Node
var actionQueue : Node

var actionRange = .3
var mouse

var target : Node3D = Node3D.new()


@onready var AQ : ActionQueue = $ActionQueue

func _ready():
	pass
func getChampData():
	pass
	#$GetChampData.getChampion(champId)
	
func _physics_process(delta):
	if stunned:
		return
	if(currentHealth <= 0):
		currentHealth = maxHealth
	if(position.distance_to(destination) > .2):
		look_at(target.position, Vector3.UP)
		transform.origin += position.direction_to(destination) * moveSpeed * delta
	else:
		stop()
		#move_and_slide()

func stop():
	destination = position
	moving = false
func move(movTarget = target):
	target = movTarget
	destination = movTarget.position
	moving = true
	
func setAttackingState(targetPlayer):
		pass
		#$ActionQueue.pushBack(targetPlayer, 5, $AbilityHandler.aac)

func updateBaseStats(data):
	pass
	#State.BaseStats = data
	#State.BaseStats[currentHealth] = State.BaseStats[maxHealth]

func _on_timer_timeout():
	pass
	#State.MovementState[pos] = position
	#rpc("updateState", State)
	
func _on_channel(action):
	channel = true
func _on_channel_complete(action):
	channel = false
func _on_channel_cancel(action):
	channel = false
