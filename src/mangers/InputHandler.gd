extends Node

var abilityName = ""
var action = preload("res://src/mangers/action.tscn")
signal keyReleased(ability)

@rpc("any_peer") func input(input, mouse, keyReleased ,targetName = null):
	
	var caster = $"../PlayersMan".get_node(str(multiplayer.get_remote_sender_id()))
	caster.mouse = mouse
	if(input == ""):
		return
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
	if(keyReleased):
		self.keyReleased.emit(abilityName)

	var cd = AH.has_node(abilityName+"CD")
	if cd:
		return
	var ability = AH.instanceAbility(abilityName)
	var target
	if(targetName==null && ability.tracking):
		return
	if(targetName!=null):
		target = get_parent().get_node("PlayersMan").get_node(targetName)
		if !ability.allyCast && target == caster:
			return
		if(!ability.tracking):
			target = targetNode
	else:
		target = targetNode
	
	ability.setTarget(target)
	AH.addAbility(ability)
	AQ.pushBack(ability,target)
