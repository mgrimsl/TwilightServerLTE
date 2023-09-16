class_name RobbinA2 extends Ability

var debuffTime = 2

func _on_channel(action):
	get_parent().target.position.y = .1
func _on_channel_complete(action):
	pass
func _on_hit(proj, body):
	if body != actor: 
		body.currentHealth -= damage
		body.stunned = true
		await get_tree().create_timer(debuffTime).timeout
		body.stunned = false
		#ability.despawnProjectile()
