extends Node

var abilityName = ""
var action = preload("res://src/mangers/action.tscn")
signal keyReleased(ability)

@rpc("any_peer") func input(input, aMouse, gMouse, keyReleased ,targetName = null):
	var player = $"../PlayersMan".get_node(str(multiplayer.get_remote_sender_id()))
	var target = null
	if (targetName != null):
		target = get_parent().get_node("PlayersMan").get_node(str(targetName))
		player.mouse = target.position
		if target == null:
			return
	else:
		target = Node3D.new()
		target.name = "targetNode"
		target.position = aMouse
		player.mouse = aMouse
	if(keyReleased):
		self.keyReleased.emit(input)
		return
	if(input == ""):
		return
		
	var AQ = player.AQ
	
	if input == "Right-Click":
		if targetName != null:
			input = "AA"
		else:
			var action = Action.new()
			action.actor = player
			action.target = target
			AQ.pushBack(action)
			return
	var ability = player.get_node(input)
	
	if ability.CDTimeLeft > 0:
		return
	ability.target = target
	if (!ability.allyCast && target == player):
		return

	AQ.pushBack(ability)
	
