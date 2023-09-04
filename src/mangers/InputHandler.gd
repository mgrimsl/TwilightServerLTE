extends Node

var abilityName = ""

@rpc("any_peer") func input(input, mouse, targetName = null):
	if(input == ""):
		return
	var caster = $"../PlayersMan".get_node(str(multiplayer.get_remote_sender_id()))
	var AH = caster.get_node("AbilityHandler")
	var AQ = caster.get_node("ActionQueue")
	var targetNode = Node3D.new()

	targetNode.name = "tempNode"
	targetNode.position = mouse
	match input:
		"Ability1":
			abilityName = "A1"
		"Ability2":
			abilityName = "A2"
		"Ability3":
			abilityName = "A3"
		"Ability4":
			abilityName = "A4"
		"Right-Click":
			abilityName = "AA"
	var ability = AH.get_node(abilityName)
	if(targetName==null && ability.tracking):
		return
	if(targetName!=null && ability.tracking):
		ability.target = get_parent().get_node("PlayersMan").get_node(targetName)
	else:
		ability.target = targetNode
	AQ.pushBack(ability)
