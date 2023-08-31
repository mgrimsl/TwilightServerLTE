extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(target, subject):
	var targetPlayer = get_node(target)
	var player = get_node(str(subject))
	player.setAttackingState(targetPlayer)

	
#@rpc("unreliable", "any_peer", "call_local") func updatePos(id,pos):
	#print("update")
#	print("update")
#	if multiplayer.get_remote_sender_id() == id:
#		var player : CharacterBody2D
#		player = get_node(id)
#		player.position = lerp(player.position, pos, 1)
			
		
