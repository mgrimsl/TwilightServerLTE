class_name RobbinA1 extends Ability

var isChannel = false
var origin = actor
@export var debuffTime = 2
var active = false
var hit = false
#var test = "A1"
func _process(delta):
	super(delta)
	if isChannel:
		actor.look_at(actor.mouse, Vector3.UP)
		projectile.travelDistance += projectile.travelDistance * delta * .50
		projectile.speed += projectile.speed * delta * .50
		damage += damage * delta * .50
		var target = Node3D.new()
		target.position = actor.mouse
		actor.target = target

func _on_channel(action):
	isChannel = true
	actor.moveSpeed *= .40

func _on_channel_cancled(action):
	_on_channel_complete(action)

func _on_channel_complete(action):
	isChannel = false
	var targetNode = Node3D.new()
	targetNode.position = actor.mouse
	target = targetNode
	actor.moveSpeed /= .40
	
func _on_hit(proj, body):
	if body != actor: 
		hit = true
		body.currentHealth -= damage
		body.moveSpeed *= .40
		await get_tree().create_timer(debuffTime).timeout
		body.moveSpeed /= .40
	
func _on_at_dest(proj, dest):
	proj.queue_free()

