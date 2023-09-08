extends Node

var player
var ability = null
var channel = false
var debuffTime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var aq = get_parent().get_parent().get_node("ActionQueue")
	aq.channelAction.connect(_on_channel)
	aq.channelActionComplete.connect(_on_channel_complete)
	player = get_parent().get_parent()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if channel && ability != null && ability.travelDistance <= 18:
		player.look_at(player.mouse, Vector3.UP)
		ability.travelDistance += ability.travelDistance * delta * .50
		ability.speed += ability.speed * delta * .50
		ability.damage += ability.damage * delta * .50

func _on_channel(action):
	channel = true
	player.State["BaseStats"]["moveSpeed"] *= .40
func _on_channel_complete(action):
	if ability == null:
		return
	print("complete")
	var targetNode = Node3D.new()
	targetNode.position = player.mouse
	ability.setTarget(targetNode)
	channel = false
	player.State["BaseStats"]["moveSpeed"] /= .40
func _on_hit(body):
	if body != player: 
		body.State["BaseStats"]["currentHealth"] -= ability.damage
		body.State["BaseStats"]["moveSpeed"] *= .40
		print("start")
		await get_tree().create_timer(debuffTime).timeout
		print("done")
		body.State["BaseStats"]["moveSpeed"] /= .40
		
	queue_free()
func _at_dest(dest):
	queue_free()
	#queue_free()
func _duration_end():
	pass
