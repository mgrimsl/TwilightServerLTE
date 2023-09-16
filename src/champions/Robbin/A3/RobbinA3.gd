class_name RobbinA3 extends Ability

@export var blinkDistance = 5 

func action():
	target.position.y = 1
	target.position = actor.position + actor.position.direction_to(target.position) * blinkDistance
	actor.move(target)
	actor.position = target.position

func _process(delta):
	pass
func _on_channel(action):
	pass
func _on_channel_complete(action):
	pass
func _on_hit(proj, body):
	pass
func _at_dest(proj, dest):
	pass
func _duration_end():
	pass
