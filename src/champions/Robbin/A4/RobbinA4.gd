class_name RobbinA4 extends Ability

var timer = Timer.new()
var bodysInArea = {}

func _on_hit(proj, body):
	if(actor != body):
		bodysInArea[body.name] = body
func _on_zone_left(proj, body):
	if(actor != body):
		bodysInArea.erase(body.name)
func action():
	super()
	timer.wait_time = 1
	timer.timeout.connect(doDamage)
	add_child(timer)
	timer.start()

func doDamage():
	for body in bodysInArea:
		bodysInArea[body].currentHealth -= damage
